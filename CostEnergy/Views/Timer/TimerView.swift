import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    @StateObject private var devicesViewModel = DevicesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    DeviceSelector(
                        devices: devicesViewModel.devices,
                        selectedDevice: $viewModel.selectedDevice,
                        isRunning: viewModel.isRunning
                    )
                    
                    ConsumptionDisplay(
                        elapsedTime: viewModel.elapsedTime,
                        energy: viewModel.currentEnergy,
                        cost: viewModel.currentCost,
                        currency: viewModel.settings.currency
                    )
                    
                    VStack(spacing: 16) {
                        timerButton
                        
                        if viewModel.showSaveButton {
                            saveButton
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.showSaveButton)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle("Timer")
        }
    }
    
    private var timerButton: some View {
        Button {
            if viewModel.isRunning {
                viewModel.stopTimer()
            } else {
                viewModel.startTimer()
            }
        } label: {
            HStack {
                Image(systemName: viewModel.isRunning ? SFSymbols.stop : SFSymbols.play)
                    .font(.title3)
                
                Text(viewModel.isRunning ? "Stop" : "Start")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isRunning ? Color.red : Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(viewModel.selectedDevice == nil)
    }
    
    private var saveButton: some View {
        Button {
            viewModel.saveUsageRecord()
        } label: {
            HStack {
                Image(systemName: SFSymbols.save)
                    .font(.title3)
                
                Text("Save Usage")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    TimerView()
}

