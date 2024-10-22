import UIKit
import FirebaseAuth

class PhoneViewController: UIViewController {
    
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
        view.backgroundColor = .systemBackground
        
        view.addSubview(phoneField)
        view.addSubview(getCodeButton)
        
        NSLayoutConstraint.activate([
            phoneField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            phoneField.widthAnchor.constraint(equalToConstant: 250),
            phoneField.heightAnchor.constraint(equalToConstant: 50),
            
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
