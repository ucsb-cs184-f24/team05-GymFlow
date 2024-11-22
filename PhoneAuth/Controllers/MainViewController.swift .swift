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
        
        let forecastVC = ForeCastController()
        forecastVC.tabBarItem = UITabBarItem(title: "Forecast", image: UIImage(systemName: "figure.walk.circle"), tag: 2)
        
        viewControllers = [homeVC, forecastVC,logoutVC]
        
        // Customize tab bar appearance
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = .systemBlue
    }
}
