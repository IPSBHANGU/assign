//
//  WeatherCollectionViewCell.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: UIElements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temeratureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        cityLabel.font = UIFont(name: "Rubik-Light", size: 12)
        temeratureLabel.font = UIFont(name: "Rubik-Regular", size: 14)
    }

    func setupCell(image:UIImage, city:String, temperature:String) {
        imageView.image = image
        cityLabel.text = city
        temeratureLabel.text = temperature
    }
}
