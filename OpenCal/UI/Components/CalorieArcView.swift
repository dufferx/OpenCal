import SwiftUI

struct CalorieArcView: View {
    let consumed: Double
    let goal: Double

    // MARK: - Derived

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(consumed / goal, 1.0)
    }

    private var formattedConsumed: String {
        "\(Int(consumed))"
    }

    private var formattedGoal: String {
        "\(Int(goal))"
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            CalorieArcShape(
                progress: progress,
                formattedConsumed: formattedConsumed,
                formattedGoal: formattedGoal
            )
        }
        .frame(maxWidth: .infinity)
        .padding(AppConstants.Spacing.cardPadding)
        .padding(.vertical, 16)
        .background(AppConstants.Colors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
        .padding(.horizontal, AppConstants.Spacing.screenHorizontal)

    }
}

// MARK: - Preview

#Preview("Half full") {
    CalorieArcView(consumed: 900, goal: 1800)
        .padding(.vertical)
        .background(AppConstants.Colors.backgroundPrimary)
}

#Preview("Over goal") {
    CalorieArcView(consumed: 2100, goal: 1800)
        .padding(.vertical)
        .background(AppConstants.Colors.backgroundPrimary)
}

#Preview("Empty") {
    CalorieArcView(consumed: 0, goal: 1800)
        .padding(.vertical)
        .background(AppConstants.Colors.backgroundPrimary)
}
