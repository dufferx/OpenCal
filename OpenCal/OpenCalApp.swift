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
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                AppRootView()
                    .environment(appState)
                    .modelContainer(ModelContainer.shared)
            } else {
                OnboardingContainerView()
                    .environment(appState)
            }
        }
    }
}
