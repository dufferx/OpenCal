import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            Tab("Home", systemImage: "house.fill", value: "home") {
                HomeView()
                    .environmentObject(homeViewModel)
            }

            Tab("Progress", systemImage: "chart.bar.fill", value: "progress") {
                ProgressView()
            }

            Tab("Food Log", systemImage: "fork.knife", value: "foodlog") {
                LibraryView()
            }

            Tab("Add", systemImage: "plus", value: "add", role: .search) {
                QuickActionSheetView(
                    onSaveEntry: { entry in
                        Task { await homeViewModel.saveEntry(entry) }
                    }
                )
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(.black)
        .onAppear { homeViewModel.appState = appState }
    }
}

#Preview {
    AppRootView()
        .environmentObject(AppState())
}
