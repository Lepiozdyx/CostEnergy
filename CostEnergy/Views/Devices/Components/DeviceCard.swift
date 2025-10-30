import SwiftUI

struct DeviceCard: View {
    let device: Device
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: device.iconName)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Text("\(device.powerConsumption.formatted(decimals: 2)) kW")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(device.usageType)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: SFSymbols.delete)
            }
            
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: SFSymbols.edit)
            }
            .tint(.blue)
        }
    }
}

#Preview {
    DeviceCard(
        device: Device(name: "Air Conditioner", powerConsumption: 2.5, usageType: "Cooling"),
        onEdit: {},
        onDelete: {}
    )
    .padding()
}

