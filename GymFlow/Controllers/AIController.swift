import UIKit
import GoogleGenerativeAI

class AIController: UIViewController {
    var generativeModel: GenerativeModel?
    var workoutText: String?
    var titleLabel: UILabel?
    var scrollView: UIScrollView!
    var contentView: UIView!
    var workoutPrompts: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitleLabel()
        setupScrollView()
        setupButtons()

        initializeGenerativeModel()
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel?.text = "Workout Guide"
        titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        titleLabel?.textColor = .black
        titleLabel?.textAlignment = .center
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel!)

        NSLayoutConstraint.activate([
            titleLabel!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
    }

    private func initializeGenerativeModel() {
        guard let apiKey = loadAPIKey() else {
            print("Error: Unable to load API key")
            return
        }

        generativeModel = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: apiKey
        )
    }

    private func setupButtons() {
        let buttonTitles = ["Push", "Pull", "Legs", "Cardio"]
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        for title in buttonTitles {
            let containerView = UIView()
            containerView.layer.cornerRadius = 15
            containerView.clipsToBounds = true
            containerView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(containerView)
            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true

            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)

            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            containerView.addSubview(button)

            // Determine the image name based on the button title
            let imageName: String
            if title == "Cardio" {
                imageName = "workout_1"
            } else if title == "Push" {
                imageName = "workout_2"
            } else if title == "Pull" {
                imageName = "workout_3"
            } else {
                imageName = "workout_4"
            }

            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                button.topAnchor.constraint(equalTo: containerView.topAnchor),
                button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }

        if let workout = workoutPrompts[title] {
            // Use the saved workout
            showPopup(message: workout)
        } else {
            // Fetch the workout from the API
            guard let generativeModel = generativeModel else {
                print("GenerativeModel is not initialized")
                return
            }

            fetchWorkoutPrompt(for: title, generativeModel: generativeModel) { [weak self] success, message in
                if success {
                    self?.workoutPrompts[title] = message // Save the fetched workout
                    self?.showPopup(message: message)
                } else {
                    self?.showPopup(message: "Failed to fetch workout prompt.")
                }
            }
        }
    }

    private func fetchWorkoutPrompt(for action: String, generativeModel: GenerativeModel, completion: @escaping (Bool, String) -> Void) {
        let prompt = "Give me a workout for \(action.lowercased()). Max 1000 characters, bullet point format with dashes."

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

    private func loadAPIKey() -> String? {
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
