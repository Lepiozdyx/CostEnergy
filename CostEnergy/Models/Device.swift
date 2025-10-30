import Foundation

struct Device: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var powerConsumption: Double
    var usageType: String
    var iconName: String
    var averageDailyHours: Int
    var averageDailyMinutes: Int
    var colorName: String
    
    init(
        id: UUID = UUID(),
        name: String,
        powerConsumption: Double,
        usageType: String,
        iconName: String = "bolt.fill",
        averageDailyHours: Int = 0,
        averageDailyMinutes: Int = 0,
        colorName: String = "raspberry"
    ) {
        self.id = id
        self.name = name
        self.powerConsumption = powerConsumption
        self.usageType = usageType
        self.iconName = iconName
        self.averageDailyHours = averageDailyHours
        self.averageDailyMinutes = averageDailyMinutes
        self.colorName = colorName
    }
    
    var totalDailyMinutes: Int {
        averageDailyHours * 60 + averageDailyMinutes
    }
    
    var totalDailyHours: Double {
        Double(totalDailyMinutes) / 60.0
    }
    
    func dailyCost(tariffRate: Double) -> Double {
        let energyKWh = (powerConsumption / 1000.0) * totalDailyHours
        return energyKWh * tariffRate
    }
    
    var formattedDailyTime: String {
        if averageDailyHours == 0 && averageDailyMinutes == 0 {
            return "0h 0m"
        } else if averageDailyHours == 0 {
            return "\(averageDailyMinutes)m"
        } else if averageDailyMinutes == 0 {
            return "\(averageDailyHours)h"
        } else {
            return "\(averageDailyHours)h \(averageDailyMinutes)m"
        }
    }
}

