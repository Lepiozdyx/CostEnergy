import Foundation

extension Double {
    func formatted(decimals: Int = 2) -> String {
        String(format: "%.\(decimals)f", self)
    }
    
    func formattedEnergy() -> String {
        "\(formatted(decimals: 3)) kWh"
    }
    
    func formattedCurrency(currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "\(formatted(decimals: 2)) \(currency)"
    }
}

extension TimeInterval {
    func formattedDuration() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

