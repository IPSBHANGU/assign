//
//  UITabBar+Extenstions.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit

extension UITabBarController {
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        guard let tabBar = self.tabBar as UIView?, let window = self.view.window else { return }

        let tabBarHeight = tabBar.frame.size.height
        let offsetY = hidden ? tabBarHeight : -tabBarHeight

        let targetFrame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                tabBar.frame = targetFrame
                self.view.frame = CGRect(
                    x: self.view.frame.origin.x,
                    y: self.view.frame.origin.y,
                    width: self.view.frame.width,
                    height: self.view.frame.height + offsetY * (hidden ? -1 : 1)
                )
                self.view.layoutIfNeeded()
            })
        } else {
            tabBar.frame = targetFrame
        }
    }
}
