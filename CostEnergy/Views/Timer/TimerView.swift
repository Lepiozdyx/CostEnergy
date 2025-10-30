import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var viewModel: TimerViewModel
    @StateObject private var devicesViewModel = DevicesViewModel()
    @State private var showingDeviceSelector = false
    
    private var availableDevices: [Device] {
        let usedDeviceIDs = Set(viewModel.timerStates.map { $0.deviceID })
        return devicesViewModel.devices.filter { !usedDeviceIDs.contains($0.id) }
    }
    
    private var currencySymbol: String {
        switch viewModel.settings.currency {
        case "RUB", "₽": return "₽"
        case "USD", "$": return "$"
        case "EUR", "€": return "€"
        default: return viewModel.settings.currency
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                
                if devicesViewModel.devices.isEmpty {
                    emptyStateNoDevices
                } else if viewModel.timerStates.isEmpty {
                    emptyStateNoTimers
                } else {
                    timersList
                }
            }
            .bgGradient()
        }
        .sheet(isPresented: $showingDeviceSelector) {
            deviceSelectorSheet
        }
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Timer-calculator")
                    .font(.system(size: 24))
                    .foregroundStyle(.mustard)
                
                Text("Track consumption in real time")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            if viewModel.canAddTimer
            && !devicesViewModel.devices.isEmpty
            && !availableDevices.isEmpty {
                addTimerButton
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 8)
    }
    
    private var emptyStateNoDevices: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.mustard.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: SFSymbols.timer)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.mustard)
                }
                
                Text("No devices for tracking")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                
                Text("Add devices in the \"Devices\" section to use the timer")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
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
            .padding()
            
            Spacer()
            Spacer()
        }
    }
    
    private var emptyStateNoTimers: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.mustard.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: SFSymbols.timer)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.mustard)
                }
                
                Text("No active timers")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                
                Text("Tap the button below to start tracking device usage")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                
                if !availableDevices.isEmpty {
                    Button {
                        showingDeviceSelector = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: SFSymbols.add)
                                .resizable()
                                .frame(width: 12, height: 12)
                            
                            Text("Add timer")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.mustard)
                        )
                    }
                    .padding(.top, 8)
                }
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
            .padding()
            
            Spacer()
            Spacer()
        }
    }
    
    private var timersList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.timerStates.enumerated()), id: \.element.id) { index, state in
                    if let device = viewModel.getDevice(for: state, from: devicesViewModel.devices) {
                        VStack(spacing: 8) {
                            deviceInfoHeader(device: device)
                            
                            TimerCard(
                                timerState: state,
                                device: device,
                                energy: viewModel.getCurrentEnergy(for: state, device: device),
                                cost: viewModel.getCurrentCost(for: state, device: device),
                                currency: currencySymbol,
                                onStart: {},
                                onPause: {
                                    viewModel.pauseTimer(at: index)
                                },
                                onResume: {
                                    viewModel.resumeTimer(at: index)
                                },
                                onReset: {
                                    viewModel.resetTimer(at: index)
                                },
                                onSave: {
                                    viewModel.saveUsageRecord(at: index, devices: devicesViewModel.devices)
                                }
                            )
                        }
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                }
                
                if !viewModel.timerStates.isEmpty {
                    totalInfoSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, viewModel.canAddTimer && !availableDevices.isEmpty ? 100 : 20)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.timerStates.count)
    }
    
    private func deviceInfoHeader(device: Device) -> some View {
        HStack {
            Text("\(device.name) (\(Int(device.powerConsumption))W)")
                .font(.system(size: 20))
                .foregroundStyle(.white.opacity(0.5))
            
            Spacer()
        }
    }
    
    private var totalInfoSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Power of appliance:")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.5))
                
                Spacer()
                
                Text("\(totalPowerConsumption) W")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            HStack {
                Text("Tariff:")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.5))
                
                Spacer()
                
                Text("\(viewModel.settings.tariffRate.formatted(decimals: 2)) \(currencySymbol)/kWh")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
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
    
    private var totalPowerConsumption: Int {
        let total = viewModel.timerStates.compactMap { state in
            devicesViewModel.devices.first(where: { $0.id == state.deviceID })?.powerConsumption
        }.reduce(0, +)
        return Int(total)
    }
    
    private var addTimerButton: some View {
        Button {
            showingDeviceSelector = true
        } label: {
            HStack(spacing: 6) {
                Image(systemName: SFSymbols.add)
                    .resizable()
                    .frame(width: 12, height: 12)
                
                Text("Add")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.mustard)
            )
        }
    }
    
    private var deviceSelectorSheet: some View {
        VStack(spacing: 0) {
            sheetHeader
            
            if availableDevices.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "bolt.slash.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white.opacity(0.3))
                    
                    Text("No available devices")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text("All devices are already being tracked")
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(availableDevices) { device in
                            Button {
                                viewModel.startTimer(for: device)
                                showingDeviceSelector = false
                            } label: {
                                HStack {
                                    Text("\(device.name) (\(Int(device.powerConsumption))W)")
                                        .font(.system(size: 18))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
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
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
        }
        .bgGradient()
        .presentationDetents([.medium, .large])
    }
    
    private var sheetHeader: some View {
        HStack {
            Spacer()
            
            Text("Select device")
                .font(.system(size: 22))
                .foregroundStyle(.mustard)
            
            Spacer()
            
            Button {
                showingDeviceSelector = false
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
        .padding(.vertical, 16)
    }
}

#Preview {
    TimerView()
        .environmentObject(TimerViewModel())
}
