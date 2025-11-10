import SwiftUI

struct MainMenuView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        MainTabView()
            .environmentObject(timerViewModel)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                timerViewModel.onScenePhaseChange(.background)
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                timerViewModel.onScenePhaseChange(newPhase)
            }
    }
}

#Preview {
    MainMenuView()
}
