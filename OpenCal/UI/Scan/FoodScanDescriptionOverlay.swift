import SwiftUI

struct FoodScanDescriptionOverlay: View {
    @ObservedObject var viewModel: FoodScanViewModel
    @Binding var localDescription: String
    @FocusState.Binding var descriptionFocused: Bool
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Spacer()

            // Single unified card: action bar + description input
            VStack(spacing: 0) {

                // Action bar row
                HStack {
                    Button {
                        descriptionFocused = false
                        viewModel.retake()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular, in: Circle())
                    }

                    Spacer()

                    Text("Meal Scan")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Button {
                        descriptionFocused = false
                        viewModel.userDescription = localDescription
                        onDismiss()  // close camera immediately
                        Task { await viewModel.analyzeImage() }
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular.tint(.orange), in: Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Description input row
                HStack(spacing: 12) {
                    TextField("Add Details", text: $localDescription)
                        .focused($descriptionFocused)
                        .submitLabel(.done)
                        .onSubmit { descriptionFocused = false }
                        .font(.system(size: 16))
                        .foregroundStyle(.primary)

                    if let image = viewModel.capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 52, height: 52)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(duration: 0.35), value: viewModel.capturedImage != nil)
    }
}
