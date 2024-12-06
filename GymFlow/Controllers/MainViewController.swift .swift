import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Home Tab - Welcome Screen
        let homeVC = AccountViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // AI Tab - Workouts Screen
        let aiVC = AIController()
        aiVC.tabBarItem = UITabBarItem(title: "Workouts", image: UIImage(systemName: "person.fill"), tag: 2)
        
        // Forecast Tab
        let forecastVC = ForeCastController()
        forecastVC.tabBarItem = UITabBarItem(title: "Forecast", image: UIImage(systemName: "figure.walk.circle"), tag: 4)
        
        // ID Tab
        let idVC = IDController()
        idVC.tabBarItem = UITabBarItem(title: "ID", image: UIImage(systemName: "creditcard"), tag: 5)
        
        // Nutrition Tab
        let mealVC = MealPlanViewController()
        mealVC.tabBarItem = UITabBarItem(title: "Nutrition", image: UIImage(systemName: "fork.knife"), tag: 6)
        
        viewControllers = [homeVC, forecastVC, aiVC, idVC, mealVC]
        
        // Customize tab bar appearance
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = .white
        
        // Add a border to the tab bar
        addTabBarBorder()
    }
    
    private func addTabBarBorder() {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.lightGray.cgColor // Customize border color
        borderLayer.frame = CGRect(x: 0, y: -10, width: tabBar.frame.width, height: 1) // 1px border at the top of the tab bar
        
        tabBar.layer.addSublayer(borderLayer)
    }
}
