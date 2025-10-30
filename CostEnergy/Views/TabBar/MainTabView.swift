import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DevicesView()
                .tabItem {
                    Label("Devices", systemImage: SFSymbols.devices)
                }
            
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: SFSymbols.timer)
                }
            
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: SFSymbols.statistics)
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: SFSymbols.settings)
                }
        }
    }
}

#Preview {
    MainTabView()
}

