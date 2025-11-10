import SwiftUI

struct SettingsView: View {
    enum Field {
        case tariffRate
        case meterReading
        case propertyName
    }
    
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showResetAlert = false
    
    @FocusState private var focusedField: Field?
    @State private var tariffRateText = ""
    @State private var meterReadingText = ""
    
    private var currencySymbol: String {
        switch viewModel.settings.currency {
        case "RUB", "₽": return "₽"
        case "USD", "$": return "$"
        case "EUR", "€": return "€"
        default: return viewModel.settings.currency
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView {
                VStack(spacing: 16) {
                    propertyNameSection
                    electricityTariffSection
                    meterReadingSection
                    accuracyCard
                    controlCard
                    calculationFormulaSection
                    resetButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
        .bgGradient()
        .onTapGesture {
            focusedField = nil
        }
        .alert("Reset All Data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                viewModel.resetAllData()
            }
        } message: {
            Text("This will permanently delete all your devices, usage records, and reset settings to default values. This action cannot be undone.")
        }
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Home Settings")
                    .font(.system(size: 24))
                    .foregroundStyle(.mustard)
                
                Text("Energy Passport of Your Home")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 8)
    }
    
    private var propertyNameSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "house")
                    .font(.system(size: 20))
                    .foregroundStyle(.sky)
                
                Text("Property Name")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            TextField("", text: Binding(
                get: { viewModel.settings.propertyName },
                set: { viewModel.updatePropertyName($0) }
            ), prompt: Text("My Apartment").foregroundStyle(.white.opacity(0.3)))
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .focused($focusedField, equals: .propertyName)
            
            Text("For example: \"My Apartment\", \"Country House\", \"Office\"")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 2)
                )
        )
    }
    
    private var electricityTariffSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "bolt")
                    .font(.system(size: 20))
                    .foregroundStyle(.mustard)
                
                Text("Electricity Tariff")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                TextField("", text: $tariffRateText)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .focused($focusedField, equals: .tariffRate)
                    .onAppear {
                        tariffRateText = formatDecimal(viewModel.settings.tariffRate)
                    }
                    .onChange(of: focusedField) { _, newValue in
                        if newValue == .tariffRate {
                            tariffRateText = formatDecimal(viewModel.settings.tariffRate)
                        } else if newValue != .tariffRate && !tariffRateText.isEmpty {
                            saveTariffRate()
                        }
                    }
                
                Menu {
                    Button {
                        viewModel.updateCurrency("USD")
                    } label: {
                        HStack {
                            Text("$")
                            Spacer()
                            if viewModel.settings.currency == "USD" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Button {
                        viewModel.updateCurrency("RUB")
                    } label: {
                        HStack {
                            Text("₽")
                            Spacer()
                            if viewModel.settings.currency == "RUB" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Button {
                        viewModel.updateCurrency("EUR")
                    } label: {
                        HStack {
                            Text("€")
                            Spacer()
                            if viewModel.settings.currency == "EUR" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(currencySymbol)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 10))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .frame(width: 60)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                }
            }
            
            Text("Cost of 1 kWh according to your tariff")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 2)
                )
        )
    }
    
    private var meterReadingSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 20))
                    .foregroundStyle(.lavender)
                
                Text("Current Meter Readings")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                TextField("", text: $meterReadingText)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .focused($focusedField, equals: .meterReading)
                    .onAppear {
                        meterReadingText = formatDecimal(viewModel.settings.currentMeterReading)
                    }
                    .onChange(of: focusedField) { _, newValue in
                        if newValue == .meterReading {
                            meterReadingText = formatDecimal(viewModel.settings.currentMeterReading)
                        } else if newValue != .meterReading && !meterReadingText.isEmpty {
                            saveMeterReading()
                        }
                    }
                
                Text("kWh")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: 60)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                            )
                    )
            }
            
            Text("For data verification and calculation calibration")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 2)
                )
        )
    }
    
    private var accuracyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.sky.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.sky)
                }
                
                Text("Accuracy")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            Text("All calculations are based on the specified power of devices and the current tariff")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.sky.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.sky.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var controlCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.mustard.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 24))
                        .foregroundStyle(.mustard)
                }
                
                Text("Control")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            Text("Regularly check the meter readings for maximum data accuracy")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.mustard.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.mustard.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var calculationFormulaSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Calculation Formula")
                .font(.system(size: 20))
                .foregroundStyle(.white.opacity(0.5))
            
            VStack(alignment: .leading, spacing: 12) {
                Text("kWh = (Power in Watts / 1000) × Time in hours")
                    .font(.system(size: 16))
                    .foregroundStyle(.sky)
                    .padding(4)
                    .background(
                        Color.white.opacity(0.05)
                    )
                
                Text("Cost = kWh × Tariff")
                    .font(.system(size: 16))
                    .foregroundStyle(.mustard)
                    .padding(4)
                    .background(
                        Color.white.opacity(0.05)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Example: An iron of 2200 W operated for 30 minutes (0.5 hours)")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text("kWh = (2200 / 1000) × 0.5 = 1.1 kWh")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text("Cost = 1.1 × \(viewModel.settings.tariffRate.formatted(decimals: 2)) = \((1.1 * viewModel.settings.tariffRate).formatted(decimals: 2)) \(currencySymbol)")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 2)
                )
        )
    }
    
    private var resetButton: some View {
        Button(role: .destructive) {
            showResetAlert = true
        } label: {
            Text("Reset progress")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.raspberry.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(.raspberry, lineWidth: 2)
                        )
                )
        }
        .padding(.top, 8)
    }
    
    private func formatDecimal(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    private func saveTariffRate() {
        let sanitized = tariffRateText.replacingOccurrences(of: ",", with: ".")
        if let value = Double(sanitized), value > 0 {
            viewModel.updateTariffRate(value)
        } else {
            viewModel.updateTariffRate(0.12)
        }
        tariffRateText = formatDecimal(viewModel.settings.tariffRate)
    }
    
    private func saveMeterReading() {
        let sanitized = meterReadingText.replacingOccurrences(of: ",", with: ".")
        if let value = Double(sanitized), value >= 0 {
            viewModel.updateMeterReading(value)
        }
        meterReadingText = formatDecimal(viewModel.settings.currentMeterReading)
    }
}

#Preview {
    SettingsView()
}

