import SwiftUI
import Combine

final class DevicesViewModel: ObservableObject {
    @Published var devices: [Device] = []
    
    private let storageManager = StorageManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadDevices()
        setupNotifications()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func setupNotifications() {
        NotificationCenter.default
            .publisher(for: NotificationNames.devicesDidUpdate)
            .sink { [weak self] _ in
                self?.loadDevices()
            }
            .store(in: &cancellables)
    }
    
    func loadDevices() {
        devices = storageManager.loadDevices()
    }
    
    func addDevice(_ device: Device) {
        devices.append(device)
        saveDevices()
    }
    
    func updateDevice(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = device
            saveDevices()
        }
    }
    
    func deleteDevice(_ device: Device) {
        NotificationCenter.default.post(
            name: NotificationNames.deviceWillBeDeleted,
            object: device.id
        )
        
        devices.removeAll { $0.id == device.id }
        saveDevices()
    }
    
    func deleteDevices(at offsets: IndexSet) {
        for index in offsets {
            let device = devices[index]
            NotificationCenter.default.post(
                name: NotificationNames.deviceWillBeDeleted,
                object: device.id
            )
        }
        
        devices.remove(atOffsets: offsets)
        saveDevices()
    }
    
    private func saveDevices() {
        storageManager.saveDevices(devices)
    }
}

