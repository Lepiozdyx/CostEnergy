import SwiftUI

struct AddDeviceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DevicesViewModel
    
    @FocusState private var isFocused: Bool
    
    let deviceToEdit: Device?
    
    @State private var name: String
    @State private var powerConsumption: String
    @State private var usageType: String
    @State private var hours: String
    @State private var minutes: String
    @State private var selectedColor: String
    
    private let colorOptions: [(name: String, color: Color)] = [
        ("raspberry", .raspberry),
        ("mustard", .mustard),
        ("lavender", .lavender),
        ("sky", .sky)
    ]
    
    init(viewModel: DevicesViewModel, deviceToEdit: Device? = nil) {
        self.viewModel = viewModel
        self.deviceToEdit = deviceToEdit
        
        _name = State(initialValue: deviceToEdit?.name ?? "")
        _powerConsumption = State(initialValue: deviceToEdit != nil ? String(Int(deviceToEdit!.powerConsumption)) : "")
        _usageType = State(initialValue: deviceToEdit?.usageType ?? UsageTypes.shortTerm)
        _hours = State(initialValue: deviceToEdit != nil ? String(deviceToEdit!.averageDailyHours) : "0")
        _minutes = State(initialValue: deviceToEdit != nil ? String(deviceToEdit!.averageDailyMinutes) : "0")
        _selectedColor = State(initialValue: deviceToEdit?.colorName ?? "raspberry")
    }
    
    private var isValid: Bool {
        !name.isEmpty && 
        !usageType.isEmpty && 
        Double(powerConsumption) != nil && 
        (Double(powerConsumption) ?? 0) > 0 &&
        Int(hours) != nil &&
        Int(minutes) != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                
                VStack(spacing: 20) {
                    subtitle
                    
                    inputField(
                        label: "Appliance name",
                        placeholder: "Enter name",
                        text: $name
                    )
                    
                    inputField(
                        label: "Power (W)",
                        placeholder: "Enter power",
                        text: $powerConsumption,
                        keyboardType: .numberPad
                    )
                    
                    usageTypePicker
                    
                    timeInputSection
                    
                    colorPicker
                }
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button {
                        saveDevice()
                    } label: {
                        Text("Add")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isValid ? .mustard : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(!isValid)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .padding(.vertical, 20)
        }
        .bgGradient()
        .onTapGesture {
            isFocused = false
        }
    }
    
    private var header: some View {
        HStack {
            Spacer()
            
            Text("Add appliance")
                .font(.system(size: 22))
                .foregroundStyle(.mustard)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.05))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var subtitle: some View {
        Text("Specify the parameters of the electrical appliance to calculate consumption")
            .font(.system(size: 18))
            .foregroundStyle(.white.opacity(0.5))
            .multilineTextAlignment(.center)
    }
    
    private func inputField(
        label: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
            
            TextField(placeholder, text: text)
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .keyboardType(keyboardType)
                .focused($isFocused)
        }
    }
    
    private var usageTypePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Type of use")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
            
            Menu {
                ForEach(UsageTypes.all, id: \.self) { type in
                    Button {
                        usageType = type
                    } label: {
                        HStack {
                            Text(type)
                            if usageType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(usageType)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 15, height: 8)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var timeInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Average daily usage time")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hours")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    TextField("0", text: $hours)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Minutes")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    TextField("0", text: $minutes)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                }
            }
        }
    }
    
    private var colorPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card color")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
            
            HStack(spacing: 16) {
                ForEach(colorOptions, id: \.name) { option in
                    Button {
                        selectedColor = option.name
                    } label: {
                        ZStack {
                            Circle()
                                .strokeBorder(option.color, lineWidth: 3)
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(option.color.opacity(0.2))
                                )
                            
                            if selectedColor == option.name {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .fontWeight(.bold)
                                    .foregroundStyle(option.color)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func saveDevice() {
        guard let power = Double(powerConsumption),
              let hrs = Int(hours),
              let mins = Int(minutes) else { return }
        
        if let existing = deviceToEdit {
            let updated = Device(
                id: existing.id,
                name: name,
                powerConsumption: power,
                usageType: usageType,
                iconName: existing.iconName,
                averageDailyHours: hrs,
                averageDailyMinutes: mins,
                colorName: selectedColor
            )
            viewModel.updateDevice(updated)
        } else {
            let newDevice = Device(
                name: name,
                powerConsumption: power,
                usageType: usageType,
                averageDailyHours: hrs,
                averageDailyMinutes: mins,
                colorName: selectedColor
            )
            viewModel.addDevice(newDevice)
        }
        
        dismiss()
    }
}

#Preview {
    AddDeviceView(viewModel: DevicesViewModel())
}

