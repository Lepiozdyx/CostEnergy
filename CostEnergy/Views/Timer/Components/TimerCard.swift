import SwiftUI

struct TimerCard: View {
    let timerState: TimerState
    let device: Device
    let energy: Double
    let cost: Double
    let currency: String
    let onPause: () -> Void
    let onResume: () -> Void
    let onStop: () -> Void
    let onSave: () -> Void
    
    private var elapsedTime: TimeInterval {
        timerState.totalElapsedTime()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: device.iconName)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name)
                        .font(.headline)
                    
                    Text("\(device.powerConsumption.formatted()) kW")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                statusIndicator
            }
            
            Divider()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Time")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(formatTime(elapsedTime))
                        .font(.title2)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Energy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(energy.formatted(.number.precision(.fractionLength(3))) + " kWh")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Cost")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(cost.formattedCurrency(currency: currency))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }
            }
            
            Divider()
            
            HStack(spacing: 12) {
                if timerState.isRunning {
                    Button {
                        if timerState.isPaused {
                            onResume()
                        } else {
                            onPause()
                        }
                    } label: {
                        HStack {
                            Image(systemName: timerState.isPaused ? SFSymbols.resume : SFSymbols.pause)
                                .font(.callout)
                            Text(timerState.isPaused ? "Resume" : "Pause")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(timerState.isPaused ? Color.green : Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                Button {
                    onStop()
                } label: {
                    HStack {
                        Image(systemName: SFSymbols.stop)
                            .font(.callout)
                        Text("Stop")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                if !timerState.isRunning {
                    Button {
                        onSave()
                    } label: {
                        HStack {
                            Image(systemName: SFSymbols.save)
                                .font(.callout)
                            Text("Save")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(timerState.isRunning && !timerState.isPaused ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
        )
    }
    
    private var statusIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(timerState.isRunning && !timerState.isPaused ? Color.green : (timerState.isPaused ? Color.orange : Color.gray))
                .frame(width: 8, height: 8)
            
            Text(timerState.isRunning && !timerState.isPaused ? "Running" : (timerState.isPaused ? "Paused" : "Stopped"))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    VStack {
        TimerCard(
            timerState: TimerState(deviceID: UUID(), startDate: Date()),
            device: Device(name: "Washing Machine", powerConsumption: 2.5, usageType: "Long-term"),
            energy: 1.234,
            cost: 0.148,
            currency: "USD",
            onPause: {},
            onResume: {},
            onStop: {},
            onSave: {}
        )
        .padding()
    }
}

