import UIKit
import GoogleGenerativeAI

class AIController: UIViewController {
    
    // Define the GenerativeModel instance (will be initialized later)
    var generativeModel: GenerativeModel?
    
    // Store the workout text returned from the API
    var workoutText: String?
    
    // Reference to the "Show Workout" button, initially nil
    var showWorkoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        
        // Load the API key and initialize the GenerativeModel after viewDidLoad
        initializeGenerativeModel()
    }
    
    private func initializeGenerativeModel() {
        // Load the API key from the plist
        guard let apiKey = loadAPIKey() else {
            print("Error: Unable to load API key")
            return
        }
        
        // Initialize the GenerativeModel with the API key
        generativeModel = GenerativeModel(
            name: "gemini-1.5-flash", // Specify the appropriate model
            apiKey: apiKey
        )
    }
    
    private func setupButtons() {
        let buttonTitles = ["Push", "Pull", "Legs", "Cardio", "Meal Plan"]
                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.distribution = .fillEqually
                stackView.alignment = .fill
                stackView.spacing = 20
                
                for title in buttonTitles {
                    let button = UIButton(type: .system)
                    button.setTitle(title, for: .normal)
                    button.setTitleColor(.white, for: .normal)
                    button.backgroundColor = title == "Meal Plan" ? .systemOrange : .systemBlue
                    button.layer.cornerRadius = 10
                    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                    
                    button.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    
                    stackView.addArrangedSubview(button)
                }
        
        // The "Show Workout" button will be added dynamically later
        let showWorkoutButton = UIButton(type: .system)
        showWorkoutButton.setTitle("Show Workout", for: .normal)
        showWorkoutButton.setTitleColor(.white, for: .normal)
        showWorkoutButton.backgroundColor = .systemGreen
        showWorkoutButton.layer.cornerRadius = 10
        showWorkoutButton.addTarget(self, action: #selector(showWorkoutButtonTapped), for: .touchUpInside)
        showWorkoutButton.isHidden = true // Initially hidden
        
        stackView.addArrangedSubview(showWorkoutButton)
        
        // Save reference to the button to update its state later
        self.showWorkoutButton = showWorkoutButton
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
                
        // Ensure the generative model is initialized before using it
        guard let generativeModel = generativeModel else {
            print("GenerativeModel is not initialized")
            return
        }
        
        // Fetch the workout prompt using the GenerativeModel API
        if title == "Meal Plan" {
            presentMealPlanView()
        }
        else{
            fetchWorkoutPrompt(for: title, generativeModel: generativeModel) {
                [weak self] success, message in
                self?.showPopup(message: message)
                
                // If the API call was successful, save the workout text and show the button
                if success {
                    self?.workoutText = message // Save the returned workout text
                    self?.showWorkoutButton?.isHidden = false // Show the "Show Workout" button
                }
            }
        }
    }
    private func presentMealPlanView() {
            let mealPlanVC = MealPlanViewController()
            mealPlanVC.modalPresentationStyle = .fullScreen
            present(mealPlanVC, animated: true, completion: nil)
        }
    private func fetchWorkoutPrompt(for action: String, generativeModel: GenerativeModel, completion: @escaping (Bool, String) -> Void) {
        // Construct the prompt based on the action
        let prompt = "Give me a workout for \(action.lowercased()). Max 1000 characters, bullet point format with dashes."
        
        // Use the GenerativeModel to fetch the workout prompt
        Task {
            do {
                let response = try await generativeModel.generateContent(prompt)
                if let workoutText = response.text {
                    completion(true, workoutText)
                } else {
                    completion(false, "Failed to receive a valid workout prompt.")
                }
            } catch {
                completion(false, "Error generating workout prompt: \(error.localizedDescription)")
            }
        }
    }
    
    private func showPopup(message: String) {
        let alert = UIAlertController(title: "Workout Prompt", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    // Action for the "Show Workout" button
    @objc private func showWorkoutButtonTapped() {
        guard let workoutText = workoutText else {
            print("No workout text available")
            return
        }
        
        // Display the saved workout text
        let alert = UIAlertController(title: "Saved Workout", message: workoutText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    // Helper method to load the API key from the plist
    private func loadAPIKey() -> String? {
        // Get the path to the GeminiAPI.plist file
        guard let path = Bundle.main.path(forResource: "GeminiAPI", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, options: [], format: nil),
              let dict = plist as? [String: Any],
              let apiKey = dict["key"] as? String else {
            return nil
        }
        return apiKey
    }
}
