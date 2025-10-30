import SwiftUI

struct AddDeviceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DevicesViewModel
    
    let deviceToEdit: Device?
    
    @State private var name: String
    @State private var powerConsumption: String
    @State private var usageType: String
    @State private var selectedIcon: String
    
    private let iconOptions = [
        "bolt.fill", "lightbulb.fill", "refrigerator.fill", "washer.fill",
        "fan.fill", "heater.vertical.fill", "tv.fill", "desktopcomputer",
        "laptopcomputer", "display", "microwave.fill", "dishwasher.fill"
    ]
    
    init(viewModel: DevicesViewModel, deviceToEdit: Device? = nil) {
        self.viewModel = viewModel
        self.deviceToEdit = deviceToEdit
        
        _name = State(initialValue: deviceToEdit?.name ?? "")
        _powerConsumption = State(initialValue: deviceToEdit?.powerConsumption.formatted(decimals: 2) ?? "")
        _usageType = State(initialValue: deviceToEdit?.usageType ?? UsageTypes.shortTerm)
        _selectedIcon = State(initialValue: deviceToEdit?.iconName ?? "bolt.fill")
    }
    
    private var isValid: Bool {
        !name.isEmpty && !usageType.isEmpty && Double(powerConsumption) != nil && (Double(powerConsumption) ?? 0) > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Device Information") {
                    TextField("Device Name", text: $name)
                    
                    TextField("Power Consumption (kW)", text: $powerConsumption)
                        .keyboardType(.decimalPad)
                    
                    Picker("Usage Type", selection: $usageType) {
                        ForEach(UsageTypes.all, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(iconOptions, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .frame(width: 60, height: 60)
                                    .background(selectedIcon == icon ? Color.blue : Color(.systemGray5))
                                    .foregroundStyle(selectedIcon == icon ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle(deviceToEdit == nil ? "Add Device" : "Edit Device")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDevice()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func saveDevice() {
        guard let power = Double(powerConsumption) else { return }
        
        if let existing = deviceToEdit {
            let updated = Device(
                id: existing.id,
                name: name,
                powerConsumption: power,
                usageType: usageType,
                iconName: selectedIcon
            )
            viewModel.updateDevice(updated)
        } else {
            let newDevice = Device(
                name: name,
                powerConsumption: power,
                usageType: usageType,
                iconName: selectedIcon
            )
            viewModel.addDevice(newDevice)
        }
        
        dismiss()
    }
}

#Preview {
    AddDeviceView(viewModel: DevicesViewModel())
}

