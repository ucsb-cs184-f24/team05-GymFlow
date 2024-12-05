import UIKit
import GoogleGenerativeAI
class MealPlanViewController: UIViewController {
    var generativeModel: GenerativeModel?
    private let mealTypeSegmentedControl: UISegmentedControl
    private let diningHallPicker: UIPickerView
    private let resultLabel: UILabel
    var FoodText: String?
    private let diningHalls = ["Carrillo", "De La Guerra", "Portola", "Ortega"]
    private let mealTypes = ["Breakfast", "Lunch", "Dinner"]
    static let baseURL = "https://api.ucsb.edu/dining/menu/v1"
    
    
    private let activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.hidesWhenStopped = true
            return indicator
        }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        mealTypeSegmentedControl = UISegmentedControl(items: mealTypes)
        diningHallPicker = UIPickerView()
        resultLabel = UILabel()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupUI()
            initializeGenerativeModel()
            view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    private func initializeGenerativeModel() {
        // Load the API key from the plist
        guard let api2Key = loadAPIKey() else {
            print("Error: Unable to load API key")
            return
        }
        
        // Initialize the GenerativeModel with the API key
        generativeModel = GenerativeModel(
            name: "gemini-1.5-flash", // Specify the appropriate model
            apiKey: api2Key
        )
    }
    
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
    private func showPopup(message: String) {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Food Prompt", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func setupUI() {
//        setupCloseButton()
        setupMealTypeSegmentedControl()
        setupDiningHallPicker()
        setupResultLabel()
        setupGenerateButton()
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupMealTypeSegmentedControl() {
        mealTypeSegmentedControl.selectedSegmentIndex = 0
        
        mealTypeSegmentedControl.tintColor = UIColor.systemBlue
        mealTypeSegmentedControl.backgroundColor = UIColor.white
        
        let font = UIFont.systemFont(ofSize: 20, weight: .medium)
        mealTypeSegmentedControl.setTitleTextAttributes([.font: font], for: .normal)
        mealTypeSegmentedControl.setTitleTextAttributes([.font: font], for: .selected)
        
        mealTypeSegmentedControl.layer.cornerRadius = 10
        mealTypeSegmentedControl.layer.masksToBounds = true
        
        mealTypeSegmentedControl.selectedSegmentTintColor = .systemBlue
        mealTypeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        mealTypeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        
        view.addSubview(mealTypeSegmentedControl)
        mealTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mealTypeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            mealTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mealTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupDiningHallPicker() {
        diningHallPicker.dataSource = self
        diningHallPicker.delegate = self
        
        view.addSubview(diningHallPicker)
        diningHallPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diningHallPicker.topAnchor.constraint(equalTo: mealTypeSegmentedControl.bottomAnchor, constant: 20),
            diningHallPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            diningHallPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            diningHallPicker.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupResultLabel() {
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        
        view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: diningHallPicker.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupGenerateButton() {
        
        let generateButton = UIButton(type: .system)
        generateButton.setTitle("Generate Meal Plan", for: .normal)
        generateButton.setTitleColor(.white, for: .normal)
        generateButton.backgroundColor = .systemGreen
        generateButton.layer.cornerRadius = 10
        generateButton.addTarget(self, action: #selector(generateMealPlan), for: .touchUpInside)
        
        view.addSubview(generateButton)
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            generateButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateButton.widthAnchor.constraint(equalToConstant: 200),
            generateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func generateMealPlan() {
        activityIndicator.startAnimating()
        let selectedMealType = mealTypes[mealTypeSegmentedControl.selectedSegmentIndex]
        let selectedDiningHall = diningHalls[diningHallPicker.selectedRow(inComponent: 0)]
        guard let generativeModel = generativeModel else {
            print("GenerativeModel is not initialized")
            return
        }
        // Convert selected meal type to API format
        let mealCode: String
        switch selectedMealType {
        case "Breakfast":
            mealCode = "breakfast"
        case "Lunch":
            mealCode = "lunch"
        case "Dinner":
            mealCode = "dinner"
        default:
            mealCode = "lunch"
        }
        
        // Convert selected dining hall to API format
        let diningCommonCode: String
        switch selectedDiningHall {
        case "Carrillo":
            diningCommonCode = "carrillo"
        case "De La Guerra":
            diningCommonCode = "de-la-guerra"
        case "Portola":
            diningCommonCode = "portola"
        default:
            diningCommonCode = "ortega"
        }
        
        // Get today's date in the required format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())

        // Show loading indicator
        DiningAPIClient.shared.getMenu(date: today, diningCommonCode: diningCommonCode, mealCode: mealCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entrees):
                    let menuItems = entrees.map { $0.name }.joined(separator: "\n")
                    
                    //self.resultLabel.text = "Menu for \(selectedMealType) at \(selectedDiningHall):\n\n\(menuItems)"
                    fetchFoodPrompt(for: menuItems, generativeModel: generativeModel) {
                        [weak self] success, message in self?.showPopup(message: message)
                            self?.activityIndicator.stopAnimating()
                            if success {
                                self?.showPopup(message: message)
                            } else {
                                self?.showPopup(message: "Error: \(message)")
                            }
                        
                        
                    }
                    
                case .failure(let error):
                    let today = Date()
                    let calendar = Calendar.current
                    let components = calendar.component(.weekday, from: today)
                    let isWeekend = components == 1 || components == 7

                    if isWeekend && mealCode == "lunch" {
                        self.showPopup(message: "If you are looking for brunch, select breakfast")
                        self.activityIndicator.stopAnimating()
                    } else {
                        self.showPopup(message: "Error: Dining commons are closed")
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
        
    }
}
private func fetchFoodPrompt(for action: String, generativeModel: GenerativeModel, completion: @escaping (Bool, String) -> Void) {
    let prompt = "Given this list of foods can you create a balanced meal that would be good for someone working out \(action.lowercased()). Max 1000 characters, give some reasoning"
    
    Task {
        do {
            let response = try await generativeModel.generateContent(prompt)
            if let foodText = response.text {
                completion(true, foodText)
            } else {
                completion(false, "Failed to receive a valid workout food prompt.")
            }
        } catch {
            completion(false, "Error generating Food prompt: \(error.localizedDescription)")
        }
    }
}

extension MealPlanViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return diningHalls.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return diningHalls[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = diningHalls[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium), // Change the font and size
            .foregroundColor: UIColor.black // Change the text color
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
