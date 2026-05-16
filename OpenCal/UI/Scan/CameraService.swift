import AVFoundation
import UIKit
import Observation

/// Manages the AVCaptureSession lifecycle and photo capture.
/// Owns the session so both the preview layer and photo output share the same pipeline.
@Observable
final class CameraService: NSObject {

    // MARK: - Public state

    let session = AVCaptureSession()
    private(set) var isCapturing = false

    // MARK: - Private

    private let photoOutput = AVCapturePhotoOutput()
    private var captureCompletion: ((UIImage?) -> Void)?

    // MARK: - Setup

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        session.sessionPreset = .photo

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device)
        else { return }

        if session.canAddInput(input)       { session.addInput(input) }
        if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }
    }

    // MARK: - Session lifecycle

    func startSession() {
        guard !session.isRunning else { return }
        Task.detached(priority: .userInitiated) { [weak self] in
            self?.session.startRunning()
        }
    }

    func stopSession() {
        guard session.isRunning else { return }
        Task.detached(priority: .background) { [weak self] in
            self?.session.stopRunning()
        }
    }

    // MARK: - Capture

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        guard !isCapturing else { return }
        isCapturing = true
        captureCompletion = completion
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        defer {
            isCapturing = false
            captureCompletion = nil
        }

        guard error == nil,
              let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data)
        else {
            captureCompletion?(nil)
            return
        }

        captureCompletion?(image)
    }
}
