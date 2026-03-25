import SwiftUI

struct MacroRingView: View {
    let label: String
    let current: Double
    let goal: Double
    let icon: String

    // MARK: - Derived

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(current / goal, 1.0)
    }

    private var formattedCurrent: String {
        "\(Int(current))"
    }

    private var formattedGoal: String {
        "of \(Int(goal))g"
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            MacroRingShape(progress: progress, icon: icon)
            MacroRingInfo(formattedCurrent: formattedCurrent, formattedGoal: formattedGoal, label: label)
        }
        .frame(width: AppConstants.Spacing.macroCardWidth, height: AppConstants.Spacing.macroCardHeight)
        .background(AppConstants.Colors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        MacroRingView(label: "Protein", current: 70, goal: 150, icon: "bolt.fill")
        MacroRingView(label: "Carbs", current: 180, goal: 200, icon: "leaf.fill")
        MacroRingView(label: "Fat", current: 55, goal: 60, icon: "drop.fill")
    }
    .padding()
    .background(AppConstants.Colors.backgroundPrimary)
}
