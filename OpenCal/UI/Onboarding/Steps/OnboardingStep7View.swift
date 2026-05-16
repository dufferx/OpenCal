import SwiftUI

struct OnboardingStep7View: View {

    var viewModel: OnboardingViewModel

    var body: some View {
        ZStack(alignment: .top) {
            AppConstants.Colors.backgroundPrimary
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Back button row
                HStack {
                    Button {
                        viewModel.goBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppConstants.Colors.textPrimary)
                            .frame(width: 36, height: 36)
                            .glassEffect(.regular, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Go back")
                    Spacer()
                    Text("7 of 7")
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textTertiary)
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)

                Spacer()

                // Heart icon — centered
                HStack {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding(.bottom, 24)

                // Title
                Text("Connect Health")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(AppConstants.Colors.textPrimary)
                    .padding(.horizontal, 24)

                // Subtitle
                Text("Sync calories burned to calculate your daily deficit")
                    .font(AppConstants.Typography.mealSubtitle)
                    .foregroundStyle(AppConstants.Colors.textSecondary)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)

                // Checklist
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(["Active calories burned", "Steps", "Workouts"], id: \.self) { item in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.green)
                            Text(item)
                                .font(AppConstants.Typography.mealSubtitle)
                                .foregroundStyle(AppConstants.Colors.textPrimary)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Button {
                    viewModel.advance()
                } label: {
                    Text("Skip")
                        .font(AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.plain)

                Button {
                    print("HealthKit request — Phase 4")
                    viewModel.advance()
                } label: {
                    Text("Allow Health Access")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppConstants.Colors.textPrimary, in: RoundedRectangle(cornerRadius: 28))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    @Previewable @State var vm = OnboardingViewModel()
    OnboardingStep7View(viewModel: vm)
}
