import SwiftUI

struct OnboardingStep6View: View {

    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack(alignment: .top) {
            AppConstants.Colors.backgroundPrimary
                .ignoresSafeArea()

            ScrollView {
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
                        Text("6 of 7")
                            .font(AppConstants.Typography.macroGoal)
                            .foregroundStyle(AppConstants.Colors.textTertiary)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                    // Title
                    Text("Connect your AI")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(AppConstants.Colors.textPrimary)
                        .padding(.top, 32)
                        .padding(.horizontal, 24)

                    // Subtitle
                    Text("Powers food photo analysis.\nYour key never leaves your device.")
                        .font(AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                        .padding(.top, 8)
                        .padding(.horizontal, 24)

                    // Provider cards
                    VStack(spacing: 12) {
                        ProviderCard(
                            title: "OpenAI",
                            subtitle: "GPT-4o Vision",
                            provider: .openAI,
                            selected: viewModel.apiProvider == .openAI
                        ) {
                            viewModel.apiProvider = .openAI
                        }
                        ProviderCard(
                            title: "Gemini",
                            subtitle: "Gemini 1.5 Pro",
                            provider: .gemini,
                            selected: viewModel.apiProvider == .gemini
                        ) {
                            viewModel.apiProvider = .gemini
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)

                    // API Key field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("API Key")
                            .font(AppConstants.Typography.macroLabel)
                            .foregroundStyle(AppConstants.Colors.textSecondary)

                        SecureField("Paste your key here", text: $viewModel.apiKey)
                            .textContentType(.password)
                            .autocorrectionDisabled()
                            .padding(14)
                            .background(
                                AppConstants.Colors.backgroundSecondary,
                                in: RoundedRectangle(cornerRadius: 14)
                            )

                        Button {
                            let url: URL?
                            switch viewModel.apiProvider {
                            case .openAI:
                                url = URL(string: "https://platform.openai.com/api-keys")
                            case .gemini:
                                url = URL(string: "https://aistudio.google.com/apikey")
                            }
                            if let url { openURL(url) }
                        } label: {
                            Text("How to get an API key →")
                                .font(AppConstants.Typography.macroGoal)
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .animation(.spring(), value: viewModel.apiProvider)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Button {
                    viewModel.skip()
                } label: {
                    Text("Skip for now")
                        .font(AppConstants.Typography.mealSubtitle)
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.plain)

                Button {
                    if !viewModel.apiKey.isEmpty {
                        KeychainHelper.save(
                            viewModel.apiKey,
                            for: AppConstants.Keychain.apiKeyIdentifier
                        )
                    }
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
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    @Previewable @StateObject var vm = OnboardingViewModel()
    OnboardingStep6View(viewModel: vm)
}
