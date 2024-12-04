import SwiftUI

struct IDView: View {
    @ObservedObject var model: IDModel

    var body: some View {
        VStack {
            if let image = model.capturedImage {
                Image(uiImage: image)
                    .resizable()
     //               .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        Text("No Image Captured")
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                    .padding()
            }

            Button(action: {
                model.checkCameraPermission()
            }) {
                Text("Take Photo")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $model.isPresentingCamera) {
                CameraCaptureView(capturedImage: $model.capturedImage)
            }
            .alert("Camera Access Denied", isPresented: $model.showPermissionDeniedAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please enable camera access in Settings to take photos.")
            }
        }
        .padding()
        .onAppear {
            model.loadImageFromDocuments()
        }
    }
}
