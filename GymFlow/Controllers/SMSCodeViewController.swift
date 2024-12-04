import UIKit
import FirebaseAuth

class SMSCodeViewController: UIViewController {
    
    private let codeField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Enter Code"
        field.returnKeyType = .continue
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(codeField)
        view.addSubview(verifyButton)
        
        codeField.delegate = self
        verifyButton.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            codeField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            codeField.widthAnchor.constraint(equalToConstant: 220),
            codeField.heightAnchor.constraint(equalToConstant: 50),
            
            verifyButton.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 20),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyButton.widthAnchor.constraint(equalToConstant: 200),
            verifyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func verifyTapped() {
        verifyCode()
    }
    
    private func verifyCode() {
        guard let code = codeField.text, !code.isEmpty else {
            showAlert(message: "Please enter the verification code")
            return
        }
        
        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if success {
                    let mainVC = MainViewController()
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true)
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "Verification failed")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SMSCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        verifyCode()
        return true
    }
}
