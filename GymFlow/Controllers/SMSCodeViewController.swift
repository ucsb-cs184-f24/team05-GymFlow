import UIKit
import FirebaseAuth

class SMSCodeViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background_image") // Replace with your actual image name
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the verification code sent to your phone."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Enter Code"
        field.returnKeyType = .continue
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.layer.cornerRadius = 10
        field.layer.masksToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the background image
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add instruction label, code field, and verify button
        view.addSubview(instructionLabel)
        view.addSubview(codeField)
        view.addSubview(verifyButton)
        
        codeField.delegate = self
        verifyButton.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            codeField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 40),
            codeField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeField.widthAnchor.constraint(equalToConstant: 250),
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
