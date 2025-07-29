//
//  PhotoCell.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit

protocol PhotoCellDelegate: AnyObject {
    func photoCellDidTapDelete(_ index: Int)
}

class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()
    private let deleteButton = UIButton(type: .system)

    weak var delegate: PhotoCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("X", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        deleteButton.layer.cornerRadius = 12
        deleteButton.clipsToBounds = true
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        contentView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // Set index as tag
    func setTag(_ index: Int) {
        deleteButton.tag = index
    }

    @objc private func deleteTapped() {
        delegate?.photoCellDidTapDelete(deleteButton.tag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
