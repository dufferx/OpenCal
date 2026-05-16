import SwiftUI

struct HomeMacroRingsView: View {
    let totalMacros: MacroNutrients
    let proteinGoal: Double
    let carbsGoal: Double
    let fatGoal: Double

    var body: some View {
        TabView {
            HStack(spacing: 10) {
                MacroRingView(
                    label: "Protein",
                    current: totalMacros.protein,
                    goal: proteinGoal,
                    icon: "proteinIcon"
                )
                MacroRingView(
                    label: "Carbs",
                    current: totalMacros.carbs,
                    goal: carbsGoal,
                    icon:"carbsIcon"
                )
                MacroRingView(
                    label: "Fat",
                    current: totalMacros.fat,
                    goal: fatGoal,
                    icon: "fatIcon"
                )
            }
            .padding(.horizontal, AppConstants.Spacing.screenHorizontal)

            Text("More stats coming soon")
                .font(AppConstants.Typography.mealSubtitle)
                .foregroundStyle(AppConstants.Colors.textSecondary)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: AppConstants.Spacing.macroCardHeight + 24)
    }
}
