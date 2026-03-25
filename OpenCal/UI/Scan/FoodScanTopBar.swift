import SwiftUI
import PhotosUI

struct FoodScanTopBar: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    let onDismiss: () -> Void

    var body: some View {
        HStack {
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .glassEffect(.regular, in: Circle())
            }

            Spacer()

            Text("Snap Your Meal")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .glassEffect(.regular, in: Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}
