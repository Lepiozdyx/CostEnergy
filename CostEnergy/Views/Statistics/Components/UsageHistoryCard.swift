import SwiftUI

struct UsageHistoryCard: View {
    let record: UsageRecord
    let deviceName: String
    
    private var cardColor: Color {
        .raspberry
    }
    
    private var currencySymbol: String {
        switch record.currency {
        case "RUB", "₽": return "₽"
        case "USD", "$": return "$"
        case "EUR", "€": return "€"
        default: return record.currency
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.mustard)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(deviceName)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                
                Text("\(record.startDate.formattedWithTime()) • \(record.duration.formattedDuration())")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(record.cost.formatted(.number.precision(.fractionLength(2)))) \(currencySymbol)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.mustard)
                
                Text("\(record.energyConsumed.formatted(.number.precision(.fractionLength(3)))) kWh")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.dark2.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        UsageHistoryCard(
            record: UsageRecord(
                deviceID: UUID(),
                startDate: Date(),
                endDate: Date().addingTimeInterval(780),
                duration: 780,
                energyConsumed: 0.008,
                cost: 0.05,
                currency: "₽"
            ),
            deviceName: "Iron"
        )
        .padding()
    }
}

