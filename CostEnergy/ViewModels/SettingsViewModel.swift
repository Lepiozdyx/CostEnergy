import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings
    
    private let storageManager = StorageManager.shared
    
    init() {
        settings = storageManager.loadSettings()
    }
    
    func updatePropertyName(_ name: String) {
        settings.propertyName = name
        saveSettings()
    }
    
    func updateCurrency(_ currency: String) {
        settings.currency = currency
        saveSettings()
    }
    
    func updateTariffRate(_ rate: Double) {
        settings.tariffRate = rate
        saveSettings()
    }
    
    func resetAllData() {
        storageManager.resetAllData()
        settings = storageManager.loadSettings()
    }
    
    private func saveSettings() {
        storageManager.saveSettings(settings)
    }
}

