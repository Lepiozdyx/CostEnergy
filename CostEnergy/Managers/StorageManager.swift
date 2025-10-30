import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func saveDevices(_ devices: [Device]) {
        guard let encoded = try? encoder.encode(devices) else { return }
        userDefaults.set(encoded, forKey: StorageKeys.devices)
        NotificationCenter.default.post(name: NotificationNames.devicesDidUpdate, object: nil)
    }
    
    func loadDevices() -> [Device] {
        guard let data = userDefaults.data(forKey: StorageKeys.devices),
              let devices = try? decoder.decode([Device].self, from: data) else {
            return []
        }
        return devices
    }
    
    func saveRecords(_ records: [UsageRecord]) {
        guard let encoded = try? encoder.encode(records) else { return }
        userDefaults.set(encoded, forKey: StorageKeys.usageRecords)
    }
    
    func loadRecords() -> [UsageRecord] {
        guard let data = userDefaults.data(forKey: StorageKeys.usageRecords),
              let records = try? decoder.decode([UsageRecord].self, from: data) else {
            return []
        }
        return records
    }
    
    func saveSettings(_ settings: AppSettings) {
        guard let encoded = try? encoder.encode(settings) else { return }
        userDefaults.set(encoded, forKey: StorageKeys.appSettings)
        NotificationCenter.default.post(name: NotificationNames.settingsDidUpdate, object: nil)
    }
    
    func loadSettings() -> AppSettings {
        guard let data = userDefaults.data(forKey: StorageKeys.appSettings),
              let settings = try? decoder.decode(AppSettings.self, from: data) else {
            return AppSettings()
        }
        return settings
    }
    
    func resetAllData() {
        userDefaults.removeObject(forKey: StorageKeys.devices)
        userDefaults.removeObject(forKey: StorageKeys.usageRecords)
        userDefaults.removeObject(forKey: StorageKeys.appSettings)
        
        NotificationCenter.default.post(name: NotificationNames.devicesDidUpdate, object: nil)
        NotificationCenter.default.post(name: NotificationNames.settingsDidUpdate, object: nil)
    }
}

