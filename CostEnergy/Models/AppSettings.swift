import Foundation

struct AppSettings: Codable {
    var propertyName: String
    var currency: String
    var tariffRate: Double
    
    init(propertyName: String = "My Property", currency: String = "USD", tariffRate: Double = 0.12) {
        self.propertyName = propertyName
        self.currency = currency
        self.tariffRate = tariffRate
    }
    
    var calculationFormula: String {
        """
        Energy (kWh) = Power (kW) × Time (hours)
        Cost = Energy (kWh) × Tariff Rate
        """
    }
}

