import Foundation
import Combine

final class TimerViewModel: ObservableObject {
    @Published var selectedDevice: Device?
    @Published var isRunning = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var currentEnergy: Double = 0
    @Published var currentCost: Double = 0
    @Published var showSaveButton = false
    @Published var settings: AppSettings
    
    private var timer: AnyCancellable?
    private var startDate: Date?
    private let calculationManager = CalculationManager.shared
    private let storageManager = StorageManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.settings = storageManager.loadSettings()
        setupNotifications()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func setupNotifications() {
        NotificationCenter.default
            .publisher(for: NotificationNames.settingsDidUpdate)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.settings = self.storageManager.loadSettings()
            }
            .store(in: &cancellables)
    }
    
    func startTimer() {
        guard selectedDevice != nil else { return }
        
        isRunning = true
        showSaveButton = false
        startDate = Date()
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimer()
            }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.cancel()
        timer = nil
        showSaveButton = true
    }
    
    func resetTimer() {
        stopTimer()
        elapsedTime = 0
        currentEnergy = 0
        currentCost = 0
        showSaveButton = false
        startDate = nil
    }
    
    func saveUsageRecord() {
        guard let device = selectedDevice,
              let start = startDate else { return }
        
        let endDate = Date()
        
        let record = UsageRecord(
            deviceID: device.id,
            startDate: start,
            endDate: endDate,
            duration: elapsedTime,
            energyConsumed: currentEnergy,
            cost: currentCost,
            currency: settings.currency
        )
        
        var records = storageManager.loadRecords()
        records.append(record)
        storageManager.saveRecords(records)
        
        resetTimer()
    }
    
    private func updateTimer() {
        guard let device = selectedDevice else { return }
        
        elapsedTime += 1
        
        currentEnergy = calculationManager.calculateEnergy(
            powerKW: device.powerConsumption,
            timeSeconds: elapsedTime
        )
        currentCost = calculationManager.calculateCost(
            energyKWh: currentEnergy,
            tariffRate: settings.tariffRate
        )
    }
}

