import SwiftUI
import AVFoundation

class IDModel: ObservableObject {
    @Published var isPresentingCamera = false
    @Published var capturedImage: UIImage? {
        didSet {
            if let image = capturedImage {
                saveImageToDocuments(image)
            }
        }
    }
    @Published var showPermissionDeniedAlert = false

    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.isPresentingCamera = true
                } else {
                    self.showPermissionDeniedAlert = true
                }
            }
        }
    }

    func saveImageToDocuments(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileURL = getDocumentsDirectory().appendingPathComponent("captured_image.jpg")
        do {
            try data.write(to: fileURL)
        } catch {
            print("Failed to save image: \(error)")
        }
    }

    func loadImageFromDocuments() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("captured_image.jpg")
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            capturedImage = image
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
