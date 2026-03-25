//
//  OpenCalApp.swift
//  OpenCal
//
//  Created by Fernando Pineda on 14/2/26.
//

import SwiftUI
import SwiftData

@main
struct OpenCalApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                AppRootView()
                    .environmentObject(appState)
                    .modelContainer(ModelContainer.shared)
            } else {
                OnboardingContainerView()
                    .environmentObject(appState)
            }
        }
    }
}
