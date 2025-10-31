import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    private var currencySymbol: String {
        let settings = StorageManager.shared.loadSettings()
        switch settings.currency {
        case "RUB", "₽": return "₽"
        case "USD", "$": return "$"
        case "EUR", "€": return "€"
        default: return settings.currency
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            periodSelector
            
            summaryCards
            
            if viewModel.filteredRecords.isEmpty {
                emptyState
            } else {
                recentSessions
            }
        }
        .bgGradient()
        .onAppear {
            viewModel.updateStatistics()
        }
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Statistics")
                    .font(.system(size: 24))
                    .foregroundStyle(.mustard)
                
                Text("Electricity consumption analysis")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 8)
    }
    
    private var periodSelector: some View {
        HStack(spacing: 0) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                Button {
                    viewModel.period = period
                } label: {
                    Text(period.rawValue)
                        .font(.system(size: 16))
                        .foregroundStyle(viewModel.period == period ? .black : .white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.period == period ?
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.mustard) :
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    private var summaryCards: some View {
        HStack(spacing: 12) {
            summaryCard(
                title: "CONSUMPTION",
                value: viewModel.totalEnergy.formatted(.number.precision(.fractionLength(2))),
                unit: "kWh",
                icon: "bolt.fill",
                color: .sky
            )
            
            summaryCard(
                title: "COST",
                value: viewModel.totalCost.formatted(.number.precision(.fractionLength(2))),
                unit: currencySymbol,
                icon: "chart.line.uptrend.xyaxis",
                color: .mustard
            )
            
            summaryCard(
                title: "SESSIONS",
                value: "\(viewModel.filteredRecords.count)",
                unit: "launches",
                icon: "chart.bar.fill",
                color: .lavender
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    private func summaryCard(title: String, value: String, unit: String, icon: String, color: Color) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(0.5)
            
            Text(value)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(color)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text(unit)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var emptyState: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.mustard.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "chart.bar.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.mustard)
                }
                
                Text("No usage data")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                
                Text("Usage records will appear here after using the timer")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.white.opacity(0.1), lineWidth: 2)
                    )
            )
            .padding()
            
            Spacer()
            Spacer()
        }
    }
    
    private var recentSessions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent sessions")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredRecords) { record in
                        UsageHistoryCard(
                            record: record,
                            deviceName: viewModel.deviceName(for: record.deviceID)
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .animation(.easeInOut(duration: 0.3), value: viewModel.filteredRecords.count)
            }
        }
    }
}

#Preview {
    StatisticsView()
}

