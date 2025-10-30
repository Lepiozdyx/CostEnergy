import SwiftUI

struct UsageHistoryCard: View {
    let record: UsageRecord
    let deviceName: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(deviceName)
                        .font(.headline)
                    
                    Text(record.startDate.formattedWithTime())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 16) {
                metricItem(
                    icon: "clock.fill",
                    value: record.duration.formattedDuration(),
                    color: .blue
                )
                
                Spacer()
                
                metricItem(
                    icon: "bolt.fill",
                    value: record.energyConsumed.formattedEnergy(),
                    color: .orange
                )
                
                Spacer()
                
                metricItem(
                    icon: "dollarsign.circle.fill",
                    value: record.cost.formattedCurrency(currency: record.currency),
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
    
    private func metricItem(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    UsageHistoryCard(
        record: UsageRecord(
            deviceID: UUID(),
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            duration: 3600,
            energyConsumed: 2.5,
            cost: 0.30,
            currency: "USD"
        ),
        deviceName: "Air Conditioner"
    )
    .padding()
}

