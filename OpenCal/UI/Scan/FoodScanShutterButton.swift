import SwiftUI

struct FoodScanShutterButton: View {
    let isCapturing: Bool
    let onCapture: () -> Void

    var body: some View {
        Button(action: onCapture) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 72, height: 72)
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 4)
                    .frame(width: 84, height: 84)
                if isCapturing {
                    ProgressView()
                        .tint(.black)
                        .scaleEffect(1.3)
                }
            }
        }
        .disabled(isCapturing)
        .padding(.bottom, 64)
    }
}
