import Foundation

final class CalculationManager {
    static let shared = CalculationManager()
    
    private init() {}
    
    func calculateEnergy(powerKW: Double, timeSeconds: TimeInterval) -> Double {
        let timeHours = timeSeconds / 3600.0
        return powerKW * timeHours
    }
    
    func calculateCost(energyKWh: Double, tariffRate: Double) -> Double {
        energyKWh * tariffRate
    }
    
    func formatCurrency(amount: Double, currency: String) -> String {
        amount.formattedCurrency(currency: currency)
    }
}

