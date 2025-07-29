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
    @IBOutlet weak var darkModeSwitch: CustomSwitch!
    @IBOutlet weak var logoutContainer: UIView!
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupUserInfo()
    }
    
    func setupUI() {
        settingsTitleLabel.font = UIFont(name: "Rubik-SemiBold", size: 32)
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        userAvatar.layer.masksToBounds = true
        userAvatar.contentMode = .scaleToFill
        userNameLable.font = UIFont(name: "Rubik-SemiBold", size: 18)
        userEmailLabel.font = UIFont(name: "Rubik-Light", size: 16)
        logoutContainer.layer.cornerRadius = 10
        logoutContainer.layer.masksToBounds = true
        logoutContainer.backgroundColor = UIColorHex().hexStringToUIColor(hex: "#991B1E")
        logoutLabel.font = UIFont(name: "Rubik-SemiBold", size: 18)
        logoutLabel.textColor = .white
        setupSwitch()
    }

    func setupSwitch() {
        darkModeSwitch.title = "Dark Mode"
        darkModeSwitch.font = UIFont(name: "Rubik-Regular", size: 18)
        darkModeSwitch.onTintColor = .systemBlue
        darkModeSwitch.thumbTintColor = .white
        darkModeSwitch.delegate = self
        logoutContainer.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(logoutButtonAction))]
        darkModeSwitch.isOn = getTheme()
    }
    
    func setupUserInfo() {
        if let user = Auth.auth().currentUser {
            userNameLable.text = user.displayName
            userEmailLabel.text = user.email
            userAvatar.kf.setImage(with: user.photoURL)
        }
    }
    
    @objc func logoutButtonAction() {
        MatrialAlertView().showAlert(viewController: self, title: "Log out", message: "Are you sure you want to log out? You'll need to login again to use the app.", actions: [MaterialAlertAction(title: "Yes", titleColor: .white, backgroundColor: UIColorHex().hexStringToUIColor(hex: "#991B1E"), handler: {
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
    
    func getTheme() -> Bool {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let style = window.traitCollection.userInterfaceStyle
            if style == .dark {
                return true
            } else {
                return false
            }
        }

        return false
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

extension SettingsViewController: CustomSwitchDelegate {
    func customSwitchDidChange(_ customSwitch: CustomSwitch, isOn: Bool) {
        if isOn {
            self.applyTheme(.dark)
        } else {
            self.applyTheme(.light)
        }
    }
}
