import UIKit
import SwiftUI

class IDController: UIViewController {
    private let model = IDModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: IDView(model: model))
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
