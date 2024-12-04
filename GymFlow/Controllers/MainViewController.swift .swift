import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Home Tab - Welcome Screen
        let homeVC = AccountViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // Logout Tab - Green Screen with Log Out Button
        let logoutVC = LogoutViewController()
        logoutVC.tabBarItem = UITabBarItem(title: "Logout", image: UIImage(systemName: "arrow.backward.circle"), tag: 1)
        
        // Set view controllers for the tab bar
        
        let aiVC = AIController()
        aiVC.tabBarItem = UITabBarItem(title: "Workouts", image: UIImage(systemName: "person.fill"), tag: 2)
        
        let forecastVC = ForeCastController()
        forecastVC.tabBarItem = UITabBarItem(title: "Forecast", image: UIImage(systemName: "figure.walk.circle"), tag: 4)
        
        let idVC = IDController()
        idVC.tabBarItem = UITabBarItem(title: "ID", image: UIImage(systemName: "creditcard"), tag: 5)
        
        
        viewControllers = [homeVC, forecastVC, aiVC, idVC, logoutVC]
        
        // Customize tab bar appearance
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = UIColor(red: 73/255, green: 117/255, blue: 249/255, alpha: 1.0) // #4975F9
        
    }
}
