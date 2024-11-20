import UIKit
import SwiftUI

class ForeCastController: UIViewController {
    private let model = ForecastModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Embed SwiftUI view
        let hostingController = UIHostingController(rootView: ForeCastView(model: model))
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

