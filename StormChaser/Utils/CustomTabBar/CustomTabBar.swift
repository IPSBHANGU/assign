//
//  CustomTabBar.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

class CustomTabBar: UITabBar {
    private var itemButtons: [UIButton] = []

    override func layoutSubviews() {
        super.layoutSubviews()
        updateItemButtons()
    }

    func addItemButton(_ button: UIButton) {
        addSubview(button)
        itemButtons.append(button)
    }

    private func updateItemButtons() {
        let itemCount = CGFloat(itemButtons.count)
        let itemWidth = bounds.width / itemCount
        let itemHeight = bounds.height

        for (index, button) in itemButtons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: itemWidth),
                button.heightAnchor.constraint(equalToConstant: itemHeight),
                button.topAnchor.constraint(equalTo: topAnchor),
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: itemWidth * CGFloat(index))
            ])
        }
    }
}
