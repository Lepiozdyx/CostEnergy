import Foundation

struct Device: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var powerConsumption: Double
    var usageType: String
    var iconName: String
    
    init(id: UUID = UUID(), name: String, powerConsumption: Double, usageType: String, iconName: String = "bolt.fill") {
        self.id = id
        self.name = name
        self.powerConsumption = powerConsumption
        self.usageType = usageType
        self.iconName = iconName
    }
}

