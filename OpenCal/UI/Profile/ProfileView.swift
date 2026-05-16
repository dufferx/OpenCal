import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private let columns = [
        GridItem(.flexible(), spacing: AppConstants.Spacing.gridItemSpacing),
        GridItem(.flexible(), spacing: AppConstants.Spacing.gridItemSpacing)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppConstants.Spacing.sectionSpacing) {
                    avatarSection
                    nameCard
                    bodyStatsCard
                    dailyGoalsSection
                    aiProviderSection
                    apiKeySection
                }
                .padding(.horizontal, AppConstants.Spacing.screenHorizontal)
                .padding(.top, AppConstants.Spacing.cardPadding)
                .padding(.bottom, AppConstants.Spacing.sectionSpacing)
            }
            .background(AppConstants.Colors.backgroundPrimary)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(AppConstants.Colors.textPrimary)
                }
                ToolbarItem(placement: .status) {
                    Group {
                        if viewModel.isSaving {
                            Text("Saving...")
                                .font(AppConstants.Typography.macroGoal)
                                .foregroundStyle(AppConstants.Colors.textSecondary)
                        } else if viewModel.didSaveSuccessfully {
                            Text("Saved")
                                .font(AppConstants.Typography.macroGoal)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadProfile()
        }
        .sheet(isPresented: $viewModel.showGoalPicker) {
            FitnessGoalPickerView(
                selectedGoal: viewModel.fitnessGoal,
                onSelect: { goal in
                    viewModel.applyFitnessGoal(goal)
                    viewModel.showGoalPicker = false
                    Task { await viewModel.save() }
                }
            )
        }
        .onDisappear {
            Task { await viewModel.save() }
        }
        // Auto-save watchers
        .onChange(of: viewModel.name) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.birthDate) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.biologicalSex) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.heightCm) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.weightKg) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.calorieGoal) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.proteinGoal) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.carbsGoal) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.fatGoal) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.apiProvider) { _, _ in Task { await viewModel.save() } }
        .onChange(of: viewModel.apiKey) { _, _ in viewModel.scheduleSave() }
        .onChange(of: viewModel.profileImageData) { _, _ in Task { await viewModel.save() } }
    }

    // MARK: - Sections

    private var avatarSection: some View {
        AvatarPicker(size: AppConstants.Spacing.profileAvatarSize, imageData: $viewModel.profileImageData)
            .frame(maxWidth: .infinity)
    }

    private var nameCard: some View {
        VStack(spacing: 0) {
            FormRow(icon: "person.fill", label: "Name") {
                TextField("Your name", text: $viewModel.name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }
        }
        .background(AppConstants.Colors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
    }

    private var bodyStatsCard: some View {
        VStack(spacing: 0) {
            FormRow(icon: "calendar", label: "Birth Date") {
                DatePicker(
                    "",
                    selection: $viewModel.birthDate,
                    displayedComponents: .date
                )
                .labelsHidden()
            }

            rowDivider

            FormRow(icon: "person.2.fill", label: "Sex") {
                Picker("", selection: $viewModel.biologicalSex) {
                    ForEach(BiologicalSex.allCases) { sex in
                        Text(sex.rawValue).tag(sex)
                    }
                }
                .labelsHidden()
            }

            rowDivider

            FormRow(icon: "ruler.fill", label: "Height") {
                HStack(spacing: 4) {
                    TextField("0", text: $viewModel.heightCm)
                        .keyboardType(.decimalPad)
                    Text("cm")
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textTertiary)
                }
            }

            rowDivider

            FormRow(icon: "scalemass.fill", label: "Weight") {
                HStack(spacing: 4) {
                    TextField("0", text: $viewModel.weightKg)
                        .keyboardType(.decimalPad)
                    Text("kg")
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textTertiary)
                }
            }
        }
        .background(AppConstants.Colors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius))
    }

    private var dailyGoalsSection: some View {
        VStack(spacing: AppConstants.Spacing.cardPadding) {
            Button {
                viewModel.showGoalPicker = true
            } label: {
                HStack(spacing: AppConstants.Spacing.macroRingLineWidth) {
                    Text("✨")
                    Text("Help me set these")
                        .font(.headline)
                }
                .foregroundStyle(AppConstants.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: AppConstants.Spacing.buttonHeight)
                .background(AppConstants.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: AppConstants.Spacing.buttonCornerRadius))
            }
            .buttonStyle(.plain)

            LazyVGrid(columns: columns, spacing: AppConstants.Spacing.gridItemSpacing) {
                MacroCellView(label: "Calories", text: $viewModel.calorieGoal, unit: "kcal")
                MacroCellView(label: "Protein", text: $viewModel.proteinGoal, unit: "g")
                MacroCellView(label: "Carbs", text: $viewModel.carbsGoal, unit: "g")
                MacroCellView(label: "Fat", text: $viewModel.fatGoal, unit: "g")
            }
        }
    }

    private var aiProviderSection: some View {
        VStack(spacing: AppConstants.Spacing.providerSpacing) {
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
    }

    private var apiKeySection: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.labelSpacing) {
            Text("API Key")
                .font(AppConstants.Typography.macroLabel)
                .foregroundStyle(AppConstants.Colors.textSecondary)

            SecureField("Paste your key here", text: $viewModel.apiKey)
                .textContentType(.password)
                .autocorrectionDisabled()
                .padding(AppConstants.Spacing.textFieldPadding)
                .background(
                    AppConstants.Colors.backgroundSecondary,
                    in: RoundedRectangle(cornerRadius: AppConstants.Spacing.cardCornerRadius)
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
    }

    private var rowDivider: some View {
        Divider()
            .padding(.leading, AppConstants.Spacing.formRowIndent)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView()
    }
}
