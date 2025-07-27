//
//  AddPhotoCell.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {
    let plusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        plusLabel.text = "+"
        plusLabel.font = .systemFont(ofSize: 48, weight: .bold)
        plusLabel.textAlignment = .center
        plusLabel.textColor = .gray
        contentView.addSubview(plusLabel)

        NSLayoutConstraint.activate([
            plusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 12
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
