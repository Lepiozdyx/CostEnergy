import Foundation

struct AppSettings: Codable {
    var propertyName: String
    var currency: String
    var tariffRate: Double
    var currentMeterReading: Double
    
    init(propertyName: String = "My Property", currency: String = "USD", tariffRate: Double = 0.12, currentMeterReading: Double = 0.0) {
        self.propertyName = propertyName
        self.currency = currency
        self.tariffRate = tariffRate
        self.currentMeterReading = currentMeterReading
    }
    
    var calculationFormula: String {
        """
        Energy (kWh) = Power (kW) × Time (hours)
        Cost = Energy (kWh) × Tariff Rate
        """
    }
}

