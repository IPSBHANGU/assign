//
//  ViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit
import NVActivityIndicatorView
import GoogleSignIn

class ViewController: UIViewController {
    
    // MARK: UI Elements
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var signInButton: UIButton?
    
    let mapView = MapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupActivityIndicator()
        handleActivityIndicator(show: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUser()
    }

    func setupActivityIndicator() {
        activityIndicator.type = .circleStrokeSpin
    }
    
    func handleActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func checkUser() {
        let userLoggedIn = GoogleAuth().isUserSignedIn()
        
        if userLoggedIn {
            // NAVIGATE TO NEXT
            self.navigationController?.pushViewController(mapView, animated: true)
        } else {
            handleActivityIndicator(show: false)
            showGoogleSignInButton()
        }
    }

    func showGoogleSignInButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        self.signInButton = button

        // Custom title with image
        button.setTitle("  Sign in with Google", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setImage(UIImage(named: "google_logo"), for: .normal) // 👈 Make sure to add this asset
        button.tintColor = .label
        button.backgroundColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? UIColor.systemGray5 : UIColor.white
        }

        // Rounded + shadow
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.withAlphaComponent(0.2).cgColor

        // Size
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 240)
        ])

        // Action
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
    }

    @objc func handleGoogleSignIn() {
        print("Google Sign-In Button Pressed")
        // Call your actual Google Sign-In logic here
        GoogleAuth().signIN(viewController: self) { isSucceeded, data, error in
            if isSucceeded {
                // Handle success
                self.signInButton?.removeFromSuperview()
                self.handleActivityIndicator(show: true)
                // Navigate to next ViewController
                self.navigationController?.pushViewController(self.mapView, animated: true)
            } else {
                // Handle error
                AlertUser().alertUser(viewController: self, title: "Error", message: "Sign-in failed: \(error ?? "Unknown error")")
            }
        }
    }
    
}

