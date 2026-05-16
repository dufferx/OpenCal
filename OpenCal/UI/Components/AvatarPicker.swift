import SwiftUI
import PhotosUI

struct AvatarPicker: View {
    let size: CGFloat
    @Binding var imageData: Data?
    @State private var selectedPhoto: PhotosPickerItem? = nil

    var body: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            if let data = imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(AppConstants.Colors.backgroundSecondary)
                        .frame(width: size, height: size)
                    Image(systemName: "person.fill")
                        .font(.system(size: size * 0.4))
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                }
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        imageData = data
                    }
                }
            }
        }
    }
}
