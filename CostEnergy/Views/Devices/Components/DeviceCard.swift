import SwiftUI

struct DeviceCard: View {
    let device: Device
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var settings = StorageManager.shared.loadSettings()
    
    private var cardColor: Color {
        switch device.colorName {
        case "raspberry": return .raspberry
        case "mustard": return .mustard
        case "lavender": return .lavender
        case "sky": return .sky
        default: return .raspberry
        }
    }
    
    private var currencySymbol: String {
        switch settings.currency {
        case "RUB", "₽": return "₽"
        case "USD", "$": return "$"
        case "EUR", "€": return "€"
        default: return settings.currency
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(device.name)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button {
                        onEdit()
                    } label: {
                        Image(systemName: SFSymbols.edit)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.sky.opacity(0.7))
                            .frame(width: 32, height: 32)
                            .background(.sky.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button {
                        onDelete()
                    } label: {
                        Image(systemName: SFSymbols.delete)
                            .resizable()
                            .frame(width: 15, height: 17)
                            .foregroundStyle(.raspberry.opacity(0.7))
                            .frame(width: 32, height: 32)
                            .background(.raspberry.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            
            Text(device.usageType)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.7))
            
            HStack(spacing: 4) {
                Image(systemName: SFSymbols.devices)
                    .resizable()
                    .frame(width: 15, height: 20)
                    .foregroundStyle(cardColor)
                
                Text("\(Int(device.powerConsumption)) W")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(cardColor)
            }
            
            HStack {
                Text("Average time/day:")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                Text(device.formattedDailyTime)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            HStack {
                Text("~Cost/day:")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(device.dailyCost(tariffRate: settings.tariffRate).formatted(decimals: 2)) \(currencySymbol)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(cardColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(cardColor, lineWidth: 2)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        DeviceCard(
            device: Device(
                name: "Iron",
                powerConsumption: 2200,
                usageType: UsageTypes.shortTerm,
                averageDailyHours: 12,
                averageDailyMinutes: 30,
                colorName: "raspberry"
            ),
            onEdit: {},
            onDelete: {}
        )
        .padding()
    }
}

