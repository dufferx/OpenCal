import SwiftUI

struct MacroRingShape: View {
    let progress: Double
    let icon: String

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(
                    AppConstants.Colors.ringTrack,
                    style: StrokeStyle(
                        lineWidth: AppConstants.Spacing.macroRingLineWidth,
                        lineCap: .round
                    )
                )

            // Progress — starts at 12 o'clock, goes clockwise
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AppConstants.Colors.ringFilled,
                    style: StrokeStyle(
                        lineWidth: AppConstants.Spacing.macroRingLineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(AppConstants.Colors.textPrimary)
        }
        .frame(
            width: AppConstants.Spacing.macroRingSize,
            height: AppConstants.Spacing.macroRingSize
        )
    }
}
