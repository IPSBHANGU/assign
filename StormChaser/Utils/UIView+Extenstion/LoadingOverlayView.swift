//
//  LoadingOverlayView.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit

class LoadingOverlayView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private weak var parentViewController: UIViewController?

    init(on viewController: UIViewController) {
        self.parentViewController = viewController
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func start() {
        guard let parent = parentViewController, superview == nil else { return }
        
        if let window = parent.view.window {
            window.addSubview(self)
        } else {
            parent.view.addSubview(self)
        }
        
        activityIndicator.startAnimating()
    }

    func stop() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
}
