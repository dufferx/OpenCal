import SwiftUI

struct ScanningAnimationView: View {
    let image: UIImage
    @State private var scanLineOffset: CGFloat = 0
    @State private var scanLineOpacity: Double = 1.0
    @State private var glowOpacity: Double = 0.0
    @State private var viewHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background: captured food photo
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()

                // Dark overlay to make scan line pop
                Color.black.opacity(0.35).ignoresSafeArea()

                // Scanning line + glow
                VStack(spacing: 0) {
                    // Gradient trail above the line
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.03),
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)

                    // The scan line itself
                    ZStack {
                        // Glow layer behind the line
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 24)
                            .blur(radius: 8)
                            .opacity(glowOpacity)

                        // Main scan line
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0),
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 2)
                    }

                    Spacer()
                }
                .offset(y: scanLineOffset)
                .opacity(scanLineOpacity)

                // Bottom: "Analyzing" label with subtle pulse
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                            .opacity(glowOpacity > 0.5 ? 1.0 : 0.4)
                            .animation(
                                .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true),
                                value: glowOpacity
                            )

                        Text("Analyzing your meal...")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 60)
                }
            }
            .onAppear {
                viewHeight = geometry.size.height
                startScanAnimation()
            }
        }
        .ignoresSafeArea()
    }

    private func startScanAnimation() {
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            glowOpacity = 1.0
        }
        animateScanLine()
    }

    private func animateScanLine() {
        let height = viewHeight > 0 ? viewHeight : 800

        // Reset to top instantly
        scanLineOffset = -height * 0.5
        scanLineOpacity = 0

        // Fade in
        withAnimation(.easeIn(duration: 0.2)) {
            scanLineOpacity = 1.0
        }

        // Sweep down over 1.8 seconds
        withAnimation(.linear(duration: 1.8)) {
            scanLineOffset = height * 0.5
        }

        // After sweep completes, fade out and restart
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.8))
            withAnimation(.easeOut(duration: 0.3)) {
                scanLineOpacity = 0
            } completion: {
                animateScanLine()
            }
        }
    }
}
