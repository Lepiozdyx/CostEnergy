import SwiftUI

struct ContentView: View {
    @StateObject private var manager = StateManager()
        
    var body: some View {
        Group {
            switch manager.appState {
            case .request:
                LoadingView()
                
            case .support:
                if let url = manager.networkManager.cesURL {
                    WKWebViewManager(
                        url: url,
                        webManager: manager.networkManager
                    )
                } else {
                    WKWebViewManager(
                        url: NetworkManager.initialURL,
                        webManager: manager.networkManager
                    )
                }
                
            case .loading:
                MainMenuView()
            }
        }
        .onAppear {
            manager.stateRequest()
        }
    }
}

#Preview {
    ContentView()
}
