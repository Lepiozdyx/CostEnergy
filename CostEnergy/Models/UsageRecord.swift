import Foundation

struct UsageRecord: Identifiable, Codable {
    let id: UUID
    let deviceID: UUID
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let energyConsumed: Double
    let cost: Double
    let currency: String
    
    init(id: UUID = UUID(), deviceID: UUID, startDate: Date, endDate: Date, duration: TimeInterval, energyConsumed: Double, cost: Double, currency: String) {
        self.id = id
        self.deviceID = deviceID
        self.startDate = startDate
        self.endDate = endDate
        self.duration = duration
        self.energyConsumed = energyConsumed
        self.cost = cost
        self.currency = currency
    }
}

