import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    PeriodSelector(selectedPeriod: $viewModel.period)
                        .padding(.horizontal)
                    
                    summaryCards
                        .padding(.horizontal)
                    
                    if viewModel.filteredRecords.isEmpty {
                        emptyState
                    } else {
                        usageHistory
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .onAppear {
                viewModel.updateStatistics()
            }
        }
    }
    
    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(
                title: "Total Energy",
                value: viewModel.totalEnergy.formattedEnergy(),
                icon: "bolt.fill",
                color: .orange
            )
            
            SummaryCard(
                title: "Total Cost",
                value: viewModel.totalCost.formattedCurrency(currency: StorageManager.shared.loadSettings().currency),
                icon: "dollarsign.circle.fill",
                color: .green
            )
            
            SummaryCard(
                title: "Total Time",
                value: viewModel.totalTime.formattedDuration(),
                icon: "clock.fill",
                color: .blue
            )
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Usage Data")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Usage records will appear here after using the timer")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 60)
    }
    
    private var usageHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Usage History")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredRecords) { record in
                    UsageHistoryCard(
                        record: record,
                        deviceName: viewModel.deviceName(for: record.deviceID)
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal)
            .animation(.easeInOut, value: viewModel.filteredRecords.count)
        }
    }
}

#Preview {
    StatisticsView()
}

