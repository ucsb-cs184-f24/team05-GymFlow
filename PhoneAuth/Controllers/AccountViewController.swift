import UIKit
import SwiftUI

class AccountViewController: UIViewController {
    
    private var busyLevelText: String = "Normal"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the SwiftUI view and host it in a UIHostingController
        let busyLevelView = BusyLevelView(busyLevelText: Binding(
            get: { self.busyLevelText },
            set: { self.busyLevelText = $0 }
        ))
        
        let hostingController = UIHostingController(rootView: busyLevelView)
        
        // Add the hosting controller as a child
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Set the hosting controller's view constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Notify the hosting controller that it has been moved to a parent
        hostingController.didMove(toParent: self)
    }
}
