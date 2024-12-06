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
    
    private let hoursTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Standard Hours"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hoursTextView: UITextView = {
        let textView = UITextView()
        textView.text = """
        Monday–Thursday
        6 am – 11 pm
        Pool Hours: 6:30 am – 8 pm
        Climbing Center Hours: 11:30 am – 10 pm
        
        Friday
        6 am – 9 pm
        Pool Hours: 6:30 am – 8 pm
        Climbing Center Hours: 11:30 am – 8:30 pm
        
        Saturday
        9 am – 9 pm
        Pool Hours: 9 am – 8 pm
        Climbing Center Hours: 11:30 am – 8:30 pm
        
        Sunday
        9 am – 10 pm
        Pool Hours: 9 am – 8 pm
        Climbing Center Hours: 11:30 am – 8:30 pm
        """
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkGray
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let reducedHoursButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reduced Hours and Closures", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(openReducedHours), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(hoursTitleLabel)
        view.addSubview(hoursTextView)
        view.addSubview(reducedHoursButton)
        view.addSubview(logOutButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            hoursTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            hoursTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hoursTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            hoursTextView.topAnchor.constraint(equalTo: hoursTitleLabel.bottomAnchor, constant: 30),
            hoursTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hoursTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            reducedHoursButton.topAnchor.constraint(equalTo: hoursTextView.bottomAnchor, constant: 40),
            reducedHoursButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 200),
            logOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        logOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }
    
    @objc func openReducedHours() {
        if let url = URL(string: "https://recreation.ucsb.edu/about/hours") {
            UIApplication.shared.open(url)
        }
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
