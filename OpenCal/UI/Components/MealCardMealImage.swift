import SwiftUI

struct MealCardMealImage: View {
    let entry: FoodEntry

    @ViewBuilder
    var body: some View {
        if let data = entry.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                AppConstants.Colors.backgroundSecondary
                Image(systemName: "photo")
                    .font(.system(size: 28))
                    .foregroundStyle(AppConstants.Colors.textTertiary)
            }
        }
    }
}
