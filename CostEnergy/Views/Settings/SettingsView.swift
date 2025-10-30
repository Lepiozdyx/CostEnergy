import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showResetAlert = false
    
    private let currencies = ["USD", "RUB", "EUR"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Property Information") {
                    TextField("Property Name", text: Binding(
                        get: { viewModel.settings.propertyName },
                        set: { viewModel.updatePropertyName($0) }
                    ))
                }
                
                Section("Currency Settings") {
                    Picker("Currency", selection: Binding(
                        get: { viewModel.settings.currency },
                        set: { viewModel.updateCurrency($0) }
                    )) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Tariff Rate") {
                    HStack {
                        TextField("Rate per kWh", value: Binding(
                            get: { viewModel.settings.tariffRate },
                            set: { viewModel.updateTariffRate($0) }
                        ), format: .number)
                        .keyboardType(.decimalPad)
                        
                        Text("per kWh")
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Current rate: \(viewModel.settings.tariffRate.formattedCurrency(currency: viewModel.settings.currency)) per kWh")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Section("Calculation Formulas") {
                    VStack(alignment: .leading, spacing: 12) {
                        formulaRow(
                            title: "Energy Consumption",
                            formula: "Energy (kWh) = Power (kW) × Time (hours)"
                        )
                        
                        Divider()
                        
                        formulaRow(
                            title: "Cost Calculation",
                            formula: "Cost = Energy (kWh) × Tariff Rate"
                        )
                    }
                    .padding(.vertical, 4)
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Reset All Data")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                } footer: {
                    Text("This will delete all devices, usage records, and reset settings to default values. This action cannot be undone.")
                        .font(.caption)
                }
            }
            .navigationTitle("Settings")
            .alert("Reset All Data?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    viewModel.resetAllData()
                }
            } message: {
                Text("This will permanently delete all your devices, usage records, and reset settings to default values. This action cannot be undone.")
            }
        }
    }
    
    private func formulaRow(title: String, formula: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(formula)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    SettingsView()
}

