import Foundation
import Combine

enum StatisticsPeriod: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
}

final class StatisticsViewModel: ObservableObject {
    @Published var period: StatisticsPeriod = .day
    @Published var filteredRecords: [UsageRecord] = []
    @Published var totalEnergy: Double = 0
    @Published var totalCost: Double = 0
    @Published var totalTime: TimeInterval = 0
    
    private let storageManager = StorageManager.shared
    private let devicesViewModel = DevicesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $period
            .sink { [weak self] _ in
                self?.updateStatistics()
            }
            .store(in: &cancellables)
        
        updateStatistics()
    }
    
    func updateStatistics() {
        let allRecords = storageManager.loadRecords()
        filteredRecords = filterRecords(allRecords, for: period)
        calculateSummary()
    }
    
    func deviceName(for deviceID: UUID) -> String {
        devicesViewModel.devices.first(where: { $0.id == deviceID })?.name ?? "Unknown Device"
    }
    
    private func filterRecords(_ records: [UsageRecord], for period: StatisticsPeriod) -> [UsageRecord] {
        let now = Date()
        let _ = Calendar.current
        
        let startDate: Date
        switch period {
        case .day:
            startDate = now.startOfDay
        case .week:
            startDate = now.startOfWeek
        case .month:
            startDate = now.startOfMonth
        }
        
        return records.filter { $0.startDate >= startDate }
            .sorted { $0.startDate > $1.startDate }
    }
    
    private func calculateSummary() {
        totalEnergy = filteredRecords.reduce(0) { $0 + $1.energyConsumed }
        totalCost = filteredRecords.reduce(0) { $0 + $1.cost }
        totalTime = filteredRecords.reduce(0) { $0 + $1.duration }
    }
}

