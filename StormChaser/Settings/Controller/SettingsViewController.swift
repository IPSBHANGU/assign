//
//  SettingsViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit
import FirebaseAuth
import Kingfisher

class SettingsViewController: UIViewController {

    // MARK: UIElements
    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var appThemeContainer: UIView!
    @IBOutlet weak var appThemeLabel: UILabel!
    @IBOutlet weak var logOutContainer: UIView!
    @IBOutlet weak var logOutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupUserInfo()
        setupButton()
    }
    
    func setupUI() {
        settingsTitleLabel.font = UIFont(name: "Rubik-SemiBold", size: 18)
        userAvatar.layer.cornerRadius = 16
        userAvatar.layer.masksToBounds = true
        userNameLable.font = UIFont(name: "Rubik-SemiBold", size: 18)
        userEmailLabel.font = UIFont(name: "Rubik-Light", size: 16)
        appThemeLabel.font = UIFont(name: "Rubik-Regular", size: 16)
        appThemeLabel.text = "App Theme"
        logOutLabel.textColor = .red
        logOutLabel.text = "Log Out"
        logOutLabel.font = UIFont(name: "Rubik-SemiBold", size: 16)
    }

    func setupUserInfo() {
        if let user = Auth.auth().currentUser {
            userNameLable.text = user.displayName
            userEmailLabel.text = user.email
            userAvatar.kf.setImage(with: user.photoURL)
        }
    }
    
    func setupButton() {
        appThemeContainer.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(appThemeButtonAction))]
        logOutContainer.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(logoutButtonAction))]
    }

    @objc func appThemeButtonAction() {
        showThemeSelector()
    }
    
    @objc func logoutButtonAction() {
        MatrialAlertView().showAlert(viewController: self, title: "Log out", message: "Are you sure you want to log out? You'll need to login again to use the app.", actions: [MaterialAlertAction(title: "Yes", titleColor: .white, backgroundColor: .red, handler: {
            GoogleAuth().signOUT { isSucceeded, error in
                if let error = error {
                    MatrialAlertView().showAlert(viewController: self, title: "Error", message: error, actions: [MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                        MatrialAlertView().dismissAlert()
                    })])
                }
                
                if isSucceeded {
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }), MaterialAlertAction(title: "Cancle", titleColor: .label, backgroundColor: .systemBackground, handler: {
            MatrialAlertView().dismissAlert()
        })])
    }
    
    func showThemeSelector() {
        let systemAction = MaterialAlertAction(title: "System Default", titleColor: .label, backgroundColor: .systemBackground) {
            self.applyTheme(.unspecified)
        }

        let lightAction = MaterialAlertAction(title: "Light", titleColor: .label, backgroundColor: .systemBackground) {
            self.applyTheme(.light)
        }
        
        let darkAction = MaterialAlertAction(title: "Dark", titleColor: .label, backgroundColor: .systemBackground) {
            self.applyTheme(.dark)
        }
        
        MatrialAlertView().showAlert(viewController: self, title: "Choose App Theme", message: "Select a preferred appearance for the app.", actions: [systemAction, lightAction, darkAction])
    }
    
    func applyTheme(_ style: UIUserInterfaceStyle) {
        UserDefaults.standard.set(style.rawValue, forKey: "selectedTheme")
        
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = style
                }
            }
        }
    }

}
