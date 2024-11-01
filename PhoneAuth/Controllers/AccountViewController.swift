import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {
    
    // Title label for "Crowd Meter"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Crowd Meter"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Gauge view for crowd level
    private let gaugeView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.3)
        progressView.tintColor = .systemYellow
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    // Label for "EMPTY" on the left side
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "EMPTY"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Label for "FULL" on the right side
    private let fullLabel: UILabel = {
        let label = UILabel()
        label.text = "FULL"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // New welcome label
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to GymFlow"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.alpha = 0.0 // Start hidden for animation
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set gradient background
        setupGradientBackground()
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(gaugeView)
        view.addSubview(emptyLabel)
        view.addSubview(fullLabel)
        view.addSubview(welcomeLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Gauge view
            gaugeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gaugeView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            gaugeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            gaugeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            gaugeView.heightAnchor.constraint(equalToConstant: 20),
            
            // Empty label
            emptyLabel.centerYAnchor.constraint(equalTo: gaugeView.centerYAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: gaugeView.leadingAnchor, constant: -10),
            
            // Full label
            fullLabel.centerYAnchor.constraint(equalTo: gaugeView.centerYAnchor),
            fullLabel.leadingAnchor.constraint(equalTo: gaugeView.trailingAnchor, constant: 10),
            
            // Welcome label
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20)
        ])
        
        // Simulate crowd level
        updateGaugeWithCrowdLevel(0.6) // Example with 60% crowd level

        // Animate the welcome label
        animateWelcomeLabel()
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGreen.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8) // Stops gradient above the tab bar area
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Function to update the gauge view
    private func updateGaugeWithCrowdLevel(_ level: Float) {
        // Animate gauge to the crowd level
        UIView.animate(withDuration: 1.0) {
            self.gaugeView.setProgress(level, animated: true)
        }
    }
    
    // Function to animate the welcome label
    private func animateWelcomeLabel() {
        UIView.animate(withDuration: 1.2, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.welcomeLabel.alpha = 1.0 // Fade-in
            self.welcomeLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // Slightly enlarge
        }) { _ in
            // Bounce back to original size
            UIView.animate(withDuration: 0.3) {
                self.welcomeLabel.transform = CGAffineTransform.identity
            }
        }
    }
}
