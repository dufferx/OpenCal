import SwiftUI

struct MacroChip: View {
    let icon: String
    let value: Double
    let unit: String

    var body: some View {
        HStack(spacing: 2) {
            Group {
                if icon.contains(".") {
                    Image(systemName: icon)
                } else {
                    Image(icon)
                        .renderingMode(.template)
                }
            }
            .font(.system(size: 16))
            .foregroundStyle(AppConstants.Colors.textSecondary)

            Text("\(Int(value))\(unit)")
                .font(.system(size: 14))
                .foregroundStyle(AppConstants.Colors.textSecondary)
        }
    }
}
