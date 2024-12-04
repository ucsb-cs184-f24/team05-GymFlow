import UIKit
import FirebaseAuth

class LogoutViewController: UIViewController {
    
    private let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to #4975F9
        view.backgroundColor = UIColor(red: 73/255, green: 117/255, blue: 249/255, alpha: 1.0) // #4975F9
        
        // Add the logout button
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 200),
            logOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        logOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }
    
    @objc func logOutTapped() {
        do {
            try Auth.auth().signOut()
            let phoneVC = PhoneViewController()
            let navController = UINavigationController(rootViewController: phoneVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}