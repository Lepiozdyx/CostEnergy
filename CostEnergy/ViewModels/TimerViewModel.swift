import Foundation
import SwiftUI
import Combine

final class TimerViewModel: ObservableObject {
    @Published var timerStates: [TimerState] = []
    @Published var settings: AppSettings
    
    private var timers: [UUID: AnyCancellable] = [:]
    private let calculationManager = CalculationManager.shared
    private let storageManager = StorageManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private let maxConcurrentTimers = 3
    
    var canAddTimer: Bool {
        timerStates.count < maxConcurrentTimers
    }
    
    init() {
        self.settings = storageManager.loadSettings()
        setupNotifications()
        restoreTimers()
    }
    
    deinit {
        stopAllTimers()
        cancellables.removeAll()
        timers.removeAll()
    }
    
    private func setupNotifications() {
        NotificationCenter.default
            .publisher(for: NotificationNames.settingsDidUpdate)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.settings = self.storageManager.loadSettings()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: NotificationNames.devicesDidUpdate)
            .sink { [weak self] _ in
                self?.handleDeviceUpdate()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: NotificationNames.deviceWillBeDeleted)
            .sink { [weak self] notification in
                guard let deviceID = notification.object as? UUID else { return }
                self?.stopTimerForDevice(deviceID: deviceID)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: NotificationNames.resetDataRequested)
            .sink { [weak self] _ in
                self?.stopAllTimers()
            }
            .store(in: &cancellables)
    }
    
    private func restoreTimers() {
        let savedStates = storageManager.loadTimerStates()
        let currentDate = Date()
        
        for var state in savedStates {
            if state.isRunning && !state.isPaused {
                let elapsedSinceStart = currentDate.timeIntervalSince(state.startDate)
                state.accumulatedTime += elapsedSinceStart
            }
            
            timerStates.append(state)
            
            if state.isRunning && !state.isPaused {
                startTimerPublisher(for: state.id)
            }
        }
        
        objectWillChange.send()
    }
    
    func startTimer(for device: Device) {
        guard canAddTimer else { return }
        guard !timerStates.contains(where: { $0.deviceID == device.id }) else { return }
        
        let newState = TimerState(deviceID: device.id, startDate: Date())
        timerStates.append(newState)
        
        startTimerPublisher(for: newState.id)
        persistTimerStates()
    }
    
    func pauseTimer(at index: Int) {
        guard index < timerStates.count else { return }
        
        let timerID = timerStates[index].id
        timerStates[index].pause()
        
        timers[timerID]?.cancel()
        timers.removeValue(forKey: timerID)
        
        persistTimerStates()
    }
    
    func resumeTimer(at index: Int) {
        guard index < timerStates.count else { return }
        
        let currentDate = Date()
        timerStates[index].resume(at: currentDate)
        
        var updatedState = timerStates[index]
        updatedState.startDate = currentDate
        timerStates[index] = updatedState
        
        startTimerPublisher(for: updatedState.id)
        persistTimerStates()
    }
    
    func stopTimer(at index: Int) {
        guard index < timerStates.count else { return }
        
        let timerID = timerStates[index].id
        timerStates[index].isRunning = false
        
        timers[timerID]?.cancel()
        timers.removeValue(forKey: timerID)
        
        persistTimerStates()
    }
    
    func resetTimer(at index: Int) {
        guard index < timerStates.count else { return }
        
        let deviceID = timerStates[index].deviceID
        let timerID = timerStates[index].id
        
        timers[timerID]?.cancel()
        timers.removeValue(forKey: timerID)
        
        let newState = TimerState(id: timerID, deviceID: deviceID, startDate: Date())
        timerStates[index] = newState
        
        startTimerPublisher(for: timerID)
        persistTimerStates()
    }
    
    func saveUsageRecord(at index: Int, devices: [Device]) {
        guard index < timerStates.count else { return }
        
        let state = timerStates[index]
        guard let device = devices.first(where: { $0.id == state.deviceID }) else { return }
        
        let totalTime = state.totalElapsedTime()
        let energy = calculationManager.calculateEnergy(
            powerWatts: device.powerConsumption,
            timeSeconds: totalTime
        )
        let cost = calculationManager.calculateCost(
            energyKWh: energy,
            tariffRate: settings.tariffRate
        )
        
        let record = UsageRecord(
            deviceID: device.id,
            startDate: state.startDate,
            endDate: Date(),
            duration: totalTime,
            energyConsumed: energy,
            cost: cost,
            currency: settings.currency
        )
        
        var records = storageManager.loadRecords()
        records.append(record)
        storageManager.saveRecords(records)
        
        removeTimer(at: index)
    }
    
    func removeTimer(at index: Int) {
        guard index < timerStates.count else { return }
        
        let timerID = timerStates[index].id
        timers[timerID]?.cancel()
        timers.removeValue(forKey: timerID)
        
        timerStates.remove(at: index)
        persistTimerStates()
    }
    
    func getDevice(for state: TimerState, from devices: [Device]) -> Device? {
        devices.first(where: { $0.id == state.deviceID })
    }
    
    func getCurrentEnergy(for state: TimerState, device: Device) -> Double {
        let totalTime = state.totalElapsedTime()
        return calculationManager.calculateEnergy(
            powerWatts: device.powerConsumption,
            timeSeconds: totalTime
        )
    }
    
    func getCurrentCost(for state: TimerState, device: Device) -> Double {
        let energy = getCurrentEnergy(for: state, device: device)
        return calculationManager.calculateCost(
            energyKWh: energy,
            tariffRate: settings.tariffRate
        )
    }
    
    func onScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .background:
            persistTimerStates()
        case .active:
            recalculateTimersAfterBackground()
        default:
            break
        }
    }
    
    private func startTimerPublisher(for timerID: UUID) {
        guard timerStates.contains(where: { $0.id == timerID }) else { return }
        
        let timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        
        timers[timerID] = timer
    }
    
    private func stopTimerForDevice(deviceID: UUID) {
        guard let index = timerStates.firstIndex(where: { $0.deviceID == deviceID }) else { return }
        removeTimer(at: index)
    }
    
    private func stopAllTimers() {
        for (_, timer) in timers {
            timer.cancel()
        }
        timers.removeAll()
        timerStates.removeAll()
        persistTimerStates()
    }
    
    private func handleDeviceUpdate() {
        let availableDevices = storageManager.loadDevices()
        let availableDeviceIDs = Set(availableDevices.map { $0.id })
        
        let indicesToRemove = timerStates.enumerated().compactMap { index, state in
            availableDeviceIDs.contains(state.deviceID) ? nil : index
        }.reversed()
        
        for index in indicesToRemove {
            removeTimer(at: index)
        }
    }
    
    private func recalculateTimersAfterBackground() {
        let currentDate = Date()
        
        for index in timerStates.indices {
            if timerStates[index].isRunning && !timerStates[index].isPaused {
                let elapsedSinceStart = currentDate.timeIntervalSince(timerStates[index].startDate)
                timerStates[index].accumulatedTime += elapsedSinceStart
                timerStates[index].startDate = currentDate
            }
        }
        
        persistTimerStates()
        objectWillChange.send()
    }
    
    private func persistTimerStates() {
        storageManager.saveTimerStates(timerStates)
    }
}
