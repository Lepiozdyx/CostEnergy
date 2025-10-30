import SwiftUI

struct ConsumptionDisplay: View {
    let elapsedTime: TimeInterval
    let energy: Double
    let cost: Double
    let currency: String
    
    var body: some View {
        VStack(spacing: 24) {
            timeDisplay
            
            HStack(spacing: 20) {
                metricCard(
                    title: "Energy",
                    value: energy.formattedEnergy(),
                    icon: "bolt.fill",
                    color: .orange
                )
                
                metricCard(
                    title: "Cost",
                    value: cost.formattedCurrency(currency: currency),
                    icon: "dollarsign.circle.fill",
                    color: .green
                )
            }
        }
    }
    
    private var timeDisplay: some View {
        VStack(spacing: 8) {
            Text("Elapsed Time")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text(elapsedTime.formattedDuration())
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .monospacedDigit()
        }
        .padding(.vertical, 20)
    }
    
    private func metricCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.headline)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ConsumptionDisplay(
        elapsedTime: 3665,
        energy: 2.54,
        cost: 0.3048,
        currency: "USD"
    )
    .padding()
}

