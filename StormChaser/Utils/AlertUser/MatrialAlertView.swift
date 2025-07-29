//
//  MatrialAlertView.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

struct MaterialAlertAction {
    let title: String
    let titleColor: UIColor?
    let backgroundColor: UIColor?
    let handler: (() -> Void)?
}

class MatrialAlertView: UIView {

    private let alertContainerView = UIView()
    private let titleLabel = UILabel()
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Rubik-Regular", size: 16)
        textView.textColor = .label
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        return textView
    }()

    private let buttonsStackView = UIStackView()

    private var actions: [MaterialAlertAction] = []

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showAlert(
        viewController: UIViewController,
        title: String,
        message: String,
        alertColor: UIColor? = .label,
        actions: [MaterialAlertAction]
    ) {
        setupView()
        setupConstraints()
        
        titleLabel.text = title
        titleLabel.textColor = (title == "Error") ? UIColorHex().hexStringToUIColor(hex: "#991B1E") : alertColor
        messageTextView.text = message.isEmpty ? "❓" : message
        
        self.actions = actions
        buttonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, action) in actions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(action.title, for: .normal)
            button.setTitleColor(action.titleColor ?? .white, for: .normal)
            button.backgroundColor = action.backgroundColor ?? .darkGray
            button.titleLabel?.font = UIFont(name: "Rubik-SemiBold", size: 15)
            button.layer.cornerRadius = 8
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.tag = index
            button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
        
        self.alpha = 0
        alertContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        guard let targetView = viewController.view else { return }
        targetView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
            self.topAnchor.constraint(equalTo: targetView.topAnchor),
            self.bottomAnchor.constraint(equalTo: targetView.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.alertContainerView.transform = .identity
        }
    }

    private func setupView() {
        alertContainerView.backgroundColor = .systemBackground
        alertContainerView.layer.cornerRadius = 20
        alertContainerView.layer.borderWidth = 1
        alertContainerView.layer.borderColor = UIColor.systemGray5.cgColor

        titleLabel.font = UIFont(name: "Rubik-SemiBold", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageTextView.borderStyle = .none

        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 12

        alertContainerView.addSubview(titleLabel)
        alertContainerView.addSubview(messageTextView)
        alertContainerView.addSubview(buttonsStackView)
        self.addSubview(alertContainerView)
    }

    private func setupConstraints() {
        alertContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        let maxWidth = UIScreen.main.bounds.width * 0.85
        let maxHeight = UIScreen.main.bounds.height * 0.85

        NSLayoutConstraint.activate([
            alertContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertContainerView.widthAnchor.constraint(equalToConstant: maxWidth),
            alertContainerView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight),

            titleLabel.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -20),

            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageTextView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 20),
            messageTextView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -20),
            messageTextView.heightAnchor.constraint(equalToConstant: 44),

            buttonsStackView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func actionButtonTapped(_ sender: UIButton) {
        let action = actions[sender.tag]
        action.handler?()
        dismissAlert()
    }

    func dismissAlert() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
