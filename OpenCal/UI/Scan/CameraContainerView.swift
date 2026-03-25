import UIKit
import AVFoundation

// UIView subclass so layoutSubviews always keeps the preview layer filling the view.
// This is necessary because updateUIView fires before the view has final bounds in a sheet.
final class CameraContainerView: UIView {
    private let previewLayer: AVCaptureVideoPreviewLayer

    init(session: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        super.init(frame: .zero)
        backgroundColor = .black
        layer.addSublayer(previewLayer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not supported") }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}
