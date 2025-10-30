import SwiftUI

struct DeviceSelector: View {
    let devices: [Device]
    @Binding var selectedDevice: Device?
    let isRunning: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Device")
                .font(.headline)
            
            if devices.isEmpty {
                Text("No devices added")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Menu {
                    ForEach(devices) { device in
                        Button {
                            if !isRunning {
                                selectedDevice = device
                            }
                        } label: {
                            HStack {
                                Image(systemName: device.iconName)
                                Text(device.name)
                            }
                        }
                    }
                } label: {
                    HStack {
                        if let selected = selectedDevice {
                            Image(systemName: selected.iconName)
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(selected.name)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                
                                Text("\(selected.powerConsumption.formatted(decimals: 2)) kW")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Text("Choose a device")
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isRunning)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedDevice: Device? = nil
    
    DeviceSelector(
        devices: [
            Device(name: "Air Conditioner", powerConsumption: 2.5, usageType: "Cooling"),
            Device(name: "Heater", powerConsumption: 1.5, usageType: "Heating")
        ],
        selectedDevice: $selectedDevice,
        isRunning: false
    )
    .padding()
}

