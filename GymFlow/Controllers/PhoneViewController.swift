import UIKit
import FirebaseAuth

class PhoneViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background_image") // Replace with your actual image name
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logotrans") // Replace with your actual logo file name
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your phone number to get started."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Phone Number"
        field.keyboardType = .phonePad
        field.textAlignment = .center
        field.layer.cornerRadius = 10
        field.layer.masksToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let getCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Code", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // Add the background image view
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add the logo, welcome label, phone field, and button
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(phoneField)
        view.addSubview(getCodeButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Logo at the top center
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // Welcome label below the logo
            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -70),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Phone field below the welcome label
            phoneField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            phoneField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneField.widthAnchor.constraint(equalToConstant: 250),
            phoneField.heightAnchor.constraint(equalToConstant: 50),
            
            // Get code button below the phone field
            getCodeButton.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 20),
            getCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getCodeButton.widthAnchor.constraint(equalToConstant: 200),
            getCodeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        getCodeButton.addTarget(self, action: #selector(getCodeTapped), for: .touchUpInside)
    }
    
    @objc private func getCodeTapped() {
        guard let phoneNumber = phoneField.text, !phoneNumber.isEmpty else {
            showAlert(message: "Please enter a valid phone number")
            return
        }
        
        let formattedNumber = "+1\(phoneNumber)" // Assuming US numbers, adjust as needed
        
        AuthManager.shared.startAuth(phoneNumber: formattedNumber) { [weak self] success, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(message: "Error: \(error.localizedDescription)")
                    return
                }
                
                guard success else {
                    self.showAlert(message: "Failed to send verification code")
                    return
                }
                
                let smsCodeVC = SMSCodeViewController()
                smsCodeVC.modalPresentationStyle = .fullScreen
                self.present(smsCodeVC, animated: true)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
