import SwiftUI

struct CalorieArcShape: View {
    let progress: Double
    let formattedConsumed: String
    let formattedGoal: String

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                // Track arc — full semicircle background
                Circle()
                    .trim(from: 0.5, to: 1.0)
                    .stroke(
                        AppConstants.Colors.calorieTrack,
                        style: StrokeStyle(
                            lineWidth: AppConstants.Spacing.calorieArcLineWidth,
                            lineCap: .round
                        )
                    )

                // Progress arc — filled portion from left to right
                Circle()
                    .trim(from: 0.5, to: 0.5 + progress * 0.5)
                    .stroke(
                        AppConstants.Colors.calorieFilled,
                        style: StrokeStyle(
                            lineWidth: AppConstants.Spacing.calorieArcLineWidth,
                            lineCap: .round
                        )
                    )
            }
            // Size the full circle then constrain height to the top half only.
            // The bottom half is strokeless so no visual bleed occurs without clipping.
            .frame(
                width: AppConstants.Spacing.calorieArcWidth,
                height: AppConstants.Spacing.calorieArcWidth
            )
            .frame(
                height: AppConstants.Spacing.calorieArcHeight,
                alignment: .top
            )

            // Center content — sits at the arc's focal point (circle center)
            CalorieArcLabels(
                formattedConsumed: formattedConsumed,
                formattedGoal: formattedGoal
            )
            .padding(.bottom, 8)
            .offset(y: 20)
        }
        .frame(width: AppConstants.Spacing.calorieArcWidth)
    }
}
