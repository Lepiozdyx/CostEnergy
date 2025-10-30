import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var viewModel: TimerViewModel
    @StateObject private var devicesViewModel = DevicesViewModel()
    @State private var showingDeviceSelector = false
    
    private var availableDevices: [Device] {
        let usedDeviceIDs = Set(viewModel.timerStates.map { $0.deviceID })
        return devicesViewModel.devices.filter { !usedDeviceIDs.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.timerStates.isEmpty {
                    emptyState
                } else {
                    timersList
                }
                
                if viewModel.canAddTimer && !devicesViewModel.devices.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            addTimerButton
                                .padding(.trailing, 20)
                                .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Timer")
            .sheet(isPresented: $showingDeviceSelector) {
                deviceSelectorSheet
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: SFSymbols.timer)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Active Timers")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add a timer to start tracking device usage")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if !devicesViewModel.devices.isEmpty {
                Button {
                    showingDeviceSelector = true
                } label: {
                    HStack {
                        Image(systemName: SFSymbols.add)
                        Text("Add Timer")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
    }
    
    private var timersList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(viewModel.timerStates.enumerated()), id: \.element.id) { index, state in
                    if let device = viewModel.getDevice(for: state, from: devicesViewModel.devices) {
                        TimerCard(
                            timerState: state,
                            device: device,
                            energy: viewModel.getCurrentEnergy(for: state, device: device),
                            cost: viewModel.getCurrentCost(for: state, device: device),
                            currency: viewModel.settings.currency,
                            onPause: {
                                viewModel.pauseTimer(at: index)
                            },
                            onResume: {
                                viewModel.resumeTimer(at: index)
                            },
                            onStop: {
                                viewModel.stopTimer(at: index)
                            },
                            onSave: {
                                viewModel.saveUsageRecord(at: index, devices: devicesViewModel.devices)
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                }
            }
            .padding()
            .padding(.bottom, viewModel.canAddTimer ? 80 : 16)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.timerStates.count)
    }
    
    private var addTimerButton: some View {
        Button {
            showingDeviceSelector = true
        } label: {
            Image(systemName: SFSymbols.add)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
        }
    }
    
    private var deviceSelectorSheet: some View {
        NavigationStack {
            List {
                if availableDevices.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bolt.slash.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        
                        Text("No Available Devices")
                            .font(.headline)
                        
                        Text("All devices are already being tracked or you need to add more devices")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 40)
                } else {
                    ForEach(availableDevices) { device in
                        Button {
                            viewModel.startTimer(for: device)
                            showingDeviceSelector = false
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: device.iconName)
                                    .font(.title3)
                                    .foregroundStyle(.blue)
                                    .frame(width: 40, height: 40)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(device.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text("\(device.powerConsumption.formatted()) kW • \(device.usageType)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Select Device")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingDeviceSelector = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    TimerView()
        .environmentObject(TimerViewModel())
}
