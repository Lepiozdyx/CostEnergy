import SwiftUI

struct PeriodSelector: View {
    @Binding var selectedPeriod: StatisticsPeriod
    
    var body: some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                Text(period.rawValue)
                    .tag(period)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    @Previewable @State var period: StatisticsPeriod = .day
    
    PeriodSelector(selectedPeriod: $period)
        .padding()
}

