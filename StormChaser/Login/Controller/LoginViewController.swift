//
//  LoginViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: UIElements
    @IBOutlet weak var googleLogINButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        googleLogINButton.layer.cornerRadius = 20
        googleLogINButton.layer.masksToBounds = true
        googleLogINButton.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#554d56").cgColor
        googleLogINButton.layer.borderWidth = 1
        googleLogINButton.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 18)
        googleLogINButton.setImage(UIImage(named: "google"), for: .normal)
        googleLogINButton.setTitle("  Log in with Google", for: .normal)
        googleLogINButton.semanticContentAttribute = .forceLeftToRight
    }
    
    @IBAction func googleSignInAction(_ sender: Any) {
        // Call your actual Google Sign-In logic here
        GoogleAuth().signIN(viewController: self) { isSucceeded, data, error in
            if isSucceeded {
                // Navigate to next ViewController
                self.dismiss(animated: true, completion: nil)
            } else {
                // Handle error
                MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Sign-in failed: \(error ?? "Unknown error")", actions: [MaterialAlertAction(title: "Okay", titleColor: .white, backgroundColor: UIColorHex().hexStringToUIColor(hex: "#991B1E"), handler: {
                    MatrialAlertView().dismissAlert()
                })])
            }
            
        }
    }
    
}
