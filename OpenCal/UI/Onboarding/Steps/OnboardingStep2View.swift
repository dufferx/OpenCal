import SwiftUI

struct OnboardingStep2View: View {

    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            AppConstants.Colors.backgroundPrimary.ignoresSafeArea()

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
                    Text("2 of 7")
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textTertiary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // Title
                Text("Biological sex")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(AppConstants.Colors.textPrimary)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)

                // Subtitle
                Text("Used to personalize your goals")
                    .font(AppConstants.Typography.mealSubtitle)
                    .foregroundStyle(AppConstants.Colors.textSecondary)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)

                Spacer()

                // Selection cards
                VStack(spacing: 12) {
                    ForEach(BiologicalSex.allCases) { sex in
                        Button {
                            viewModel.biologicalSex = sex
                        } label: {
                            Text(sex.rawValue)
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    viewModel.biologicalSex == sex
                                        ? AppConstants.Colors.textPrimary
                                        : AppConstants.Colors.backgroundSecondary,
                                    in: RoundedRectangle(cornerRadius: 28)
                                )
                                .foregroundStyle(
                                    viewModel.biologicalSex == sex
                                        ? Color.white
                                        : AppConstants.Colors.textPrimary
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.advance()
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppConstants.Colors.textPrimary, in: RoundedRectangle(cornerRadius: 28))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    @Previewable @StateObject var vm = OnboardingViewModel()
    OnboardingStep2View(viewModel: vm)
}
