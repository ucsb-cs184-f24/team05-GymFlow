import UIKit
import SwiftUI
import Combine

class AccountViewController: UIViewController {
    
    private let busyLevelModel = BusyLevelModel()
    private let forecastModel = ForecastModel()
    private var hostingController: UIHostingController<BusyLevelView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the SwiftUI view and host it in a UIHostingController
        let busyLevelView = BusyLevelView(model: busyLevelModel, forecastModel: forecastModel)
        
        hostingController = UIHostingController(rootView: busyLevelView)
        
        
        if let hostingController = hostingController {
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
}
