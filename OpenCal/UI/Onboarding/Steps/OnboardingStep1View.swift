import SwiftUI
import PhotosUI

struct OnboardingStep1View: View {

    var viewModel: OnboardingViewModel
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var localName: String = ""
    @FocusState private var nameFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            AppConstants.Colors.backgroundPrimary
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Top row — placeholder keeps alignment with other steps
                HStack {
                    Color.clear.frame(width: 36, height: 36)
                    Spacer()
                    Text("1 of 7")
                        .font(AppConstants.Typography.macroGoal)
                        .foregroundStyle(AppConstants.Colors.textTertiary)
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)

                // Title
                Text("Welcome")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(AppConstants.Colors.textPrimary)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)

                // Subtitle
                Text("Add a photo and your name")
                    .font(AppConstants.Typography.mealSubtitle)
                    .foregroundStyle(AppConstants.Colors.textSecondary)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)

                Spacer()

                // Avatar + name field
                VStack(spacing: 24) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let data = viewModel.profileImageData,
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle()
                                    .fill(AppConstants.Colors.backgroundSecondary)
                                    .frame(width: 100, height: 100)
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(AppConstants.Colors.textSecondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: selectedPhoto) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                await MainActor.run {
                                    viewModel.profileImageData = data
                                }
                            }
                        }
                    }

                    TextField("Your name", text: $localName)
                        .focused($nameFocused)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .padding(12)
                        .background(AppConstants.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            let isEmpty = localName.trimmingCharacters(in: .whitespaces).isEmpty
            Button {
                viewModel.name = localName
                viewModel.advance()
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(isEmpty ? AppConstants.Colors.textSecondary : Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        isEmpty ? AppConstants.Colors.backgroundSecondary : AppConstants.Colors.textPrimary,
                        in: RoundedRectangle(cornerRadius: 28)
                    )
            }
            .disabled(isEmpty)
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .onAppear { nameFocused = true }
    }
}

#Preview {
    @Previewable @State var vm = OnboardingViewModel()
    OnboardingStep1View(viewModel: vm)
}
