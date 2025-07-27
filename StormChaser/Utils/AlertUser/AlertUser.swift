//
//  AlertUser.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit

class AlertUser:NSObject {
    /*
     Accepts 4 arguements
     title as String for title of alert
     message as String for alert meassage
     view as UIViewController
     Optional arguement to pass custom UIAlertAction Array usefull if need to add any function at alert action
     */
    func alertUser(viewController: UIViewController, title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.view.tintColor = .label   // Dynamic to Theme
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        } else {
            let defaultAction = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(defaultAction)
        }
        
        viewController.present(alert, animated: true)
    }
}
