import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraContainerView {
        CameraContainerView(session: session)
    }

    func updateUIView(_ uiView: CameraContainerView, context: Context) {}
}
