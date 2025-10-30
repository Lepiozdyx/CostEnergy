import SwiftUI

struct TimerCard: View {
    let timerState: TimerState?
    let device: Device
    let energy: Double
    let cost: Double
    let currency: String
    let onStart: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    let onReset: () -> Void
    let onSave: () -> Void
    
    private var elapsedTime: TimeInterval {
        timerState?.totalElapsedTime() ?? 0
    }
    
    private var isRunning: Bool {
        timerState?.isRunning ?? false
    }
    
    private var isPaused: Bool {
        timerState?.isPaused ?? false
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("WORKING TIME")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(1)
            
            timerDisplay
            
            HStack(spacing: 12) {
                consumptionCard
                costCard
            }
            
            controlButtons
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.mustard, lineWidth: 2)
                )
        )
    }
    
    private var timerDisplay: some View {
        HStack(spacing: 8) {
            timeComponent(value: hours, label: "HOUR")
            
            Text(":")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.mustard)
                .offset(y: -8)
            
            timeComponent(value: minutes, label: "MIN")
            
            Text(":")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.mustard)
                .offset(y: -8)
            
            timeComponent(value: seconds, label: "SEC")
        }
    }
    
    private func timeComponent(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text(String(format: "%02d", value))
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.mustard)
                .monospacedDigit()
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(0.5)
        }
        .frame(width: 90)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.mustard.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var consumptionCard: some View {
        VStack(spacing: 8) {
            Text("CONSUMPTION")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(0.5)
            
            Text(energy.formatted(.number.precision(.fractionLength(3))))
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.sky)
                .monospacedDigit()
            
            Text("kWh")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.sky.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.sky.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var costCard: some View {
        VStack(spacing: 8) {
            Text("COST")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(0.5)
            
            Text(cost.formatted(.number.precision(.fractionLength(2))))
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.mustard)
                .monospacedDigit()
            
            Text(currency)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.mustard.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.mustard.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var controlButtons: some View {
        if !isRunning {
            Button {
                onStart()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: SFSymbols.play)
                        .resizable()
                        .frame(width: 14, height: 16)
                    
                    Text("Start")
                        .font(.system(size: 20, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.4, green: 0.8, blue: 0.4))
                )
            }
        } else {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button {
                        if isPaused {
                            onResume()
                        } else {
                            onPause()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: isPaused ? SFSymbols.resume : SFSymbols.pause)
                                .resizable()
                                .frame(width: isPaused ? 14 : 14, height: 16)
                            
                            Text(isPaused ? "Resume" : "Pause")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 1.0, green: 0.6, blue: 0.3))
                        )
                    }
                    
                    Button {
                        onReset()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(width: 56, height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                }
                
                Button {
                    onSave()
                } label: {
                    Text("Finish and save")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.mustard)
                        )
                }
            }
        }
    }
    
    private var hours: Int {
        Int(elapsedTime) / 3600
    }
    
    private var minutes: Int {
        (Int(elapsedTime) % 3600) / 60
    }
    
    private var seconds: Int {
        Int(elapsedTime) % 60
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            TimerCard(
                timerState: nil,
                device: Device(name: "Iron", powerConsumption: 2200, usageType: "Short-term"),
                energy: 0.000,
                cost: 0.00,
                currency: "₽",
                onStart: {},
                onPause: {},
                onResume: {},
                onReset: {},
                onSave: {}
            )
            
            TimerCard(
                timerState: TimerState(deviceID: UUID(), startDate: Date().addingTimeInterval(-4)),
                device: Device(name: "Iron", powerConsumption: 2200, usageType: "Short-term"),
                energy: 0.002,
                cost: 0.02,
                currency: "₽",
                onStart: {},
                onPause: {},
                onResume: {},
                onReset: {},
                onSave: {}
            )
        }
        .padding()
        .bgGradient()
    }
}

