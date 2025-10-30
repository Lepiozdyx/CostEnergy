import SwiftUI

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
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
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HStack {
        SummaryCard(
            title: "Total Energy",
            value: "12.5 kWh",
            icon: "bolt.fill",
            color: .orange
        )
        
        SummaryCard(
            title: "Total Cost",
            value: "$1.50",
            icon: "dollarsign.circle.fill",
            color: .green
        )
        
        SummaryCard(
            title: "Total Time",
            value: "05:00:00",
            icon: "clock.fill",
            color: .blue
        )
    }
    .padding()
}

