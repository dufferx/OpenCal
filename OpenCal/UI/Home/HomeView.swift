import SwiftUI

struct HomeView: View {
    @Environment(HomeViewModel.self) private var viewModel
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HomeHeaderView(
                        greeting: viewModel.greeting,
                        userName: viewModel.userProfile.name,
                        profileImageData: viewModel.profileImageData,
                        onAvatarTap: { viewModel.showProfile = true }
                    )
                    CalendarStripView(
                        selectedDate: $viewModel.selectedDate,
                        datesWithLogs: viewModel.datesWithLogs
                    )
                    CalorieArcView(
                        consumed: viewModel.caloriesConsumed,
                        goal: viewModel.calorieGoal
                    )
                    HomeMacroRingsView(
                        totalMacros: viewModel.dailyLog.totalMacros,
                        proteinGoal: viewModel.userProfile.dailyProteinGoal,
                        carbsGoal: viewModel.userProfile.dailyCarbsGoal,
                        fatGoal: viewModel.userProfile.dailyFatGoal
                    )
                    HomeMealsSectionView(
                        entries: viewModel.dailyLog.entries,
                        onDelete: { id in await viewModel.deleteEntry(id: id) }
                    )
                    Spacer().frame(height: 100)
                }
                .padding(.top, 8)
            }
            .refreshable { await viewModel.loadLog() }
            .background(AppConstants.Colors.backgroundPrimary)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $viewModel.showManualEntry) {
                ManualEntryView { entry in
                    Task { await viewModel.saveEntry(entry) }
                }
            }
            .sheet(isPresented: $viewModel.showProfile, onDismiss: viewModel.reloadProfile) {
                ProfileView()
            }
        }
        .onChange(of: appState.selectedTab) { _, newTab in
            if newTab == .home {
                viewModel.onTabBecameActive()
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

}

// MARK: - Preview

#Preview {
    HomeView()
        .environment(HomeViewModel())
        .environment(AppState())
}
