//
//  CustomImageView.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

class CustomImageView: UIImageView {
    
    private let badgeLabel = UILabel()
    
    var images: [UIImage]? {
        didSet {
            updateImage()
        }
    }

    private let cameraImage = UIImage(systemName: "camera")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentMode = .scaleAspectFit
        clipsToBounds = true
        
        badgeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 9
        badgeLabel.clipsToBounds = true
        badgeLabel.isHidden = true
        
        addSubview(badgeLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let badgeSize: CGFloat = 18
        badgeLabel.frame = CGRect(
            x: bounds.width - badgeSize - 4,
            y: 4,
            width: badgeSize,
            height: badgeSize
        )
    }

    private func updateImage() {
        guard let images = images, !images.isEmpty else {
            image = cameraImage
            badgeLabel.isHidden = true
            return
        }

        image = images[0]
        if images.count > 1 {
            badgeLabel.text = "+\(images.count - 1)"
            badgeLabel.isHidden = false
        } else {
            badgeLabel.isHidden = true
        }
    }
}
