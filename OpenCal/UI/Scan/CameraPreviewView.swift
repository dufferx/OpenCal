import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    func makeUIView(context: Context) -> CameraContainerView {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        let view = CameraContainerView(session: session)

        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ),
        let input = try? AVCaptureDeviceInput(device: device) else {
            // Simulator or no camera — black background
            return view
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        Task.detached(priority: .userInitiated) {
            session.startRunning()
        }

        return view
    }

    func updateUIView(_ uiView: CameraContainerView, context: Context) {}
}
