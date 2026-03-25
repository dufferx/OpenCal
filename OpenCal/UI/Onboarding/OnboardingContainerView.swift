import SwiftUI

struct OnboardingContainerView: View {

    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            AppConstants.Colors.backgroundPrimary.ignoresSafeArea()

            Group {
                switch viewModel.currentStep {
                case 1:
                    OnboardingStep1View(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 2:
                    OnboardingStep2View(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 3:
                    OnboardingStep3View(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 4:
                    OnboardingStep4View(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 5:
                    OnboardingStep5View(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 6:
                    OnboardingStep6View(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 7:
                    OnboardingStep7View(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                default:
                    Color.clear
                }
            }
            .animation(.spring(), value: viewModel.currentStep)
        }
        .onChange(of: viewModel.currentStep) { _, newStep in
            guard newStep > viewModel.totalSteps else { return }
            Task {
                await viewModel.completeOnboarding()
                appState.completeOnboarding()
            }
        }
    }
}
