import SwiftUI

struct HomeHeaderView: View {
    let greeting: String
    let userName: String
    let profileImageData: Data?
    let onAvatarTap: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(greeting) 👋")
                    .font(AppConstants.Typography.greeting)
                    .foregroundStyle(AppConstants.Colors.textSecondary)

                Text(userName)
                    .font(AppConstants.Typography.userName)
                    .foregroundStyle(AppConstants.Colors.textPrimary)
            }

            Spacer()

            Button(action: onAvatarTap) {
                avatarView
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, AppConstants.Spacing.screenHorizontal)
    }

    @ViewBuilder
    private var avatarView: some View {
        if let data = profileImageData,
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: AppConstants.Spacing.avatarSize, height: AppConstants.Spacing.avatarSize)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(AppConstants.Colors.backgroundSecondary)
                .frame(width: AppConstants.Spacing.avatarSize, height: AppConstants.Spacing.avatarSize)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(AppConstants.Colors.textSecondary)
                }
        }
    }
}
