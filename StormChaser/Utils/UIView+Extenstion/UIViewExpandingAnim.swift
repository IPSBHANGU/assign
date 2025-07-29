//
//  UIViewExpandingAnim.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit

extension CGAffineTransform {
    init(from source: CGRect, to destination: CGRect) {
        self = CGAffineTransform.identity
            .translatedBy(x: destination.midX - source.midX, y: destination.midY - source.midY)
            .scaledBy(x: destination.width / source.width, y: destination.height / source.height)
    }
}
