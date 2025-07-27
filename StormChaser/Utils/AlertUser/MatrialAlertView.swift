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
    private let messageTextView = UITextView()
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
        if title == "Error" {
            titleLabel.textColor = UIColorHex().hexStringToUIColor(hex: "#c80000")
        } else {
            titleLabel.textColor = alertColor
        }

        if message.isEmpty {
            messageTextView.text = "❓"
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        } else {
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
            messageTextView.text = message
        }

        self.actions = actions
        buttonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, action) in actions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(action.title, for: .normal)
            button.setTitleColor(action.titleColor ?? .white, for: .normal)
            button.backgroundColor = action.backgroundColor ?? UIColorHex().hexStringToUIColor(hex: "#554d56")
            button.titleLabel?.font = UIFont(name: "Rubik-SemiBold", size: 15)
            button.layer.cornerRadius = 8
            button.tag = index
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
            button.layer.borderColor = UIColor.systemGray6.cgColor
            button.layer.borderWidth = 1
            buttonsStackView.addArrangedSubview(button)
        }

        adjustTextViewScroll(message: message)

        self.alpha = 0
        alertContainerView.transform = CGAffineTransform(scaleX: 0, y: 0)

        guard let targetView = viewController.view else { return }
        targetView.addSubview(self)

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
            self.topAnchor.constraint(equalTo: targetView.topAnchor),
            self.bottomAnchor.constraint(equalTo: targetView.bottomAnchor)
        ])

        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
            self.alertContainerView.transform = .identity
        }
    }

    private func setupView() {
        alertContainerView.backgroundColor = .systemBackground
        alertContainerView.layer.cornerRadius = 12
        alertContainerView.layer.borderWidth = 4
        alertContainerView.layer.borderColor = UIColor.systemGray6.cgColor
        alertContainerView.addShadow()

        titleLabel.font = UIFont(name: "Rubik-SemiBold", size: 20)
        titleLabel.textAlignment = .center
        alertContainerView.addSubview(titleLabel)

        messageTextView.font = UIFont(name: "Rubik-Regular", size: 15)
        messageTextView.textAlignment = .center
        messageTextView.isEditable = false
        messageTextView.showsVerticalScrollIndicator = false
        messageTextView.showsHorizontalScrollIndicator = false
        messageTextView.isSelectable = false
        messageTextView.textContainerInset = .zero
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textColor = .label
        messageTextView.backgroundColor = .clear
        alertContainerView.addSubview(messageTextView)

        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 12
        buttonsStackView.distribution = .fillEqually
        alertContainerView.addSubview(buttonsStackView)

        self.addSubview(alertContainerView)
    }

    private func setupConstraints() {
        alertContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        let messageTextViewHeightConstraint = messageTextView.heightAnchor.constraint(equalToConstant: 80)
        messageTextViewHeightConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            alertContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertContainerView.widthAnchor.constraint(equalToConstant: 328),
            alertContainerView.heightAnchor.constraint(lessThanOrEqualToConstant: 800),

            titleLabel.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -24),

            messageTextView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 24),
            messageTextView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -24),
            messageTextViewHeightConstraint,

            buttonsStackView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -24),
            buttonsStackView.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -16)
        ])
    }

    private func adjustTextViewScroll(message: String) {
        let maxAlertHeight: CGFloat = 800
        let padding: CGFloat = 100 // estimated total height of title + buttons

        let textViewWidth = alertContainerView.frame.width - 48
        let textViewHeight = message.height(withConstrainedWidth: textViewWidth, font: messageTextView.font ?? UIFont.systemFont(ofSize: 15))

        messageTextView.isScrollEnabled = (textViewHeight + padding) > maxAlertHeight
    }

    @objc private func actionButtonTapped(_ sender: UIButton) {
        let action = actions[sender.tag]
        action.handler?()
        dismissAlert()
    }

    func dismissAlert() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alertContainerView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
