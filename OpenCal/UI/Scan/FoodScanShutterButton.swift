import SwiftUI

struct FoodScanShutterButton: View {
    @ObservedObject var viewModel: FoodScanViewModel

    var body: some View {
        Button {
            viewModel.showCamera = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 72, height: 72)
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 4)
                    .frame(width: 84, height: 84)
            }
        }
        .padding(.bottom, 64)
    }
}
