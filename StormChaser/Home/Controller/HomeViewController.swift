//
//  HomeViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

class HomeViewController: UITabBarController {
    
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        let userLoggedIn = GoogleAuth().isUserSignedIn()
        
        if !userLoggedIn {
            showLoginViewController()
        } else {
            loadViews()
        }
    }
    
    private func showLoginViewController() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false, completion: nil)
    }
    
    func loadViews() {
        let listTabBarItem = UITabBarItem()
        listTabBarItem.image = UIImage(systemName: "line.3.horizontal")
        let listWeatherVC = UINavigationController(rootViewController: ListViewController())
        listWeatherVC.isNavigationBarHidden = true
        listWeatherVC.tabBarItem = listTabBarItem
        
        let settingsTabBarItem = UITabBarItem()
        settingsTabBarItem.image = UIImage(systemName: "gear")
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.isNavigationBarHidden = true
        settingsVC.tabBarItem = settingsTabBarItem
        
        self.viewControllers = [listWeatherVC, settingsVC]
        self.selectedViewController = listWeatherVC
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .secondaryLabel
    }
}
