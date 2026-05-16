import SwiftUI

struct AppRootView: View {
    @Environment(AppState.self) var appState
    @State private var homeViewModel = HomeViewModel()
    @State private var previousTab: AppTab = .home
    @State private var showQuickActionSheet = false

    var body: some View {
        @Bindable var appState = appState
        TabView(selection: $appState.selectedTab) {
            SwiftUI.Tab("Home", systemImage: "house.fill", value: AppTab.home) {
                HomeView()
                    .environment(homeViewModel)
            }

            SwiftUI.Tab("Progress", systemImage: "chart.bar.fill", value: AppTab.progress) {
                ProgressView()
            }

            SwiftUI.Tab("Food Log", systemImage: "fork.knife", value: AppTab.foodLog) {
                LibraryView()
            }

            SwiftUI.Tab("Add", systemImage: "plus", value: AppTab.add, role: .search) {
                Color.clear
            }
        }
        .sheet(isPresented: $showQuickActionSheet) {
            QuickActionSheetView(
                onOpenFoodLog: openFoodLog,
                onSaveEntry: { entry in
                    Task { await homeViewModel.saveEntry(entry) }
                }
            )
        }
        .onChange(of: appState.selectedTab) { _, newTab in
            handleTabChange(to: newTab)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(.black)
        .onAppear {
            previousTab = appState.selectedTab == .add ? .home : appState.selectedTab
            homeViewModel.appState = appState
        }
    }

    private func handleTabChange(to newTab: AppTab) {
        if newTab == .add {
            showQuickActionSheet = true
            appState.selectedTab = previousTab
        } else {
            previousTab = newTab
        }
    }

    private func openFoodLog() {
        appState.selectedTab = .foodLog
    }
}

#Preview {
    AppRootView()
        .environment(AppState())
}
