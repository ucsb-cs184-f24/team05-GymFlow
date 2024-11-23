import XCTest
import SwiftUI
import UIKit
@testable import testapp2UITests

final class ContentViewTests: XCTestCase {
    
    func testCheckCameraPermission_granted() {
        let expectation = XCTestExpectation(description: "Camera permission granted.")
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                XCTAssertTrue(granted, "Permission should be granted.")
                expectation.fulfill()
            } else {
                XCTFail("Permission was not granted.")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testCheckCameraPermission_denied() {
        let contentView = ContentView()
        contentView.showPermissionDeniedAlert = false // Reset state
        
        // Simulate denied permission
        AVCaptureDevice.requestAccess(for: .video) { _ in
            DispatchQueue.main.async {
                XCTAssertTrue(contentView.showPermissionDeniedAlert, "Permission denied alert should be shown.")
            }
        }
    }
}
