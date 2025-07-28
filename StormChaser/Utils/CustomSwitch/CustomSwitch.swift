//
//  CustomSwitch.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

protocol CustomSwitchDelegate: AnyObject {
    func customSwitchDidChange(_ customSwitch: CustomSwitch, isOn: Bool)
}

class CustomSwitch: UIView {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    
    // MARK: - Public Properties
    weak var delegate: CustomSwitchDelegate?

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var font : UIFont? {
        didSet {
            titleLabel.font = font
        }
    }

    var isOn: Bool {
        get { toggleSwitch.isOn }
        set { toggleSwitch.setOn(newValue, animated: true) }
    }

    var onTintColor: UIColor? {
        didSet {
            toggleSwitch.onTintColor = onTintColor
        }
    }

    var thumbTintColor: UIColor? {
        didSet {
            toggleSwitch.thumbTintColor = thumbTintColor
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        // Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Toggle Switch
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        addSubview(toggleSwitch)

        // Tap Gesture to toggle switch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        // Layout Constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggleSwitch.leadingAnchor, constant: -8)
        ])
    }

    // MARK: - Actions
    @objc private func viewTapped() {
        toggleSwitch.setOn(!toggleSwitch.isOn, animated: true)
        switchValueChanged(toggleSwitch)
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        delegate?.customSwitchDidChange(self, isOn: sender.isOn)
    }
}
