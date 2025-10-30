//
//  CostEnergyApp.swift
//  CostEnergy
//
//  Created by Alex on 29.10.2025.
//

import SwiftUI

@main
struct CostEnergyApp: App {
    @StateObject private var timerViewModel = TimerViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(timerViewModel)
//                .preferredColorScheme(.dark)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    timerViewModel.onScenePhaseChange(.background)
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            timerViewModel.onScenePhaseChange(newPhase)
        }
    }
}
