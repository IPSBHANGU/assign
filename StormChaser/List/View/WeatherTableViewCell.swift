//
//  WeatherTableViewCell.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    // MARK: UIElements
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }

    private func setupUI() {
        weatherImageView.layer.cornerRadius = 10
        weatherImageView.layer.masksToBounds = true
        locationLabel.font = UIFont(name: "Rubik-SemiBold", size: 24)
        weatherConditionLabel.font = UIFont(name: "Rubik-Regular", size: 18)
        temperatureLabel.font = UIFont(name: "Rubik-Light", size: 24)
        temperatureLabel.textColor = .secondaryLabel
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(image:UIImage, location:String, weatherCondition:String, temperature:String) {
        weatherImageView.image = image
        locationLabel.text = location
        weatherConditionLabel.text = weatherCondition
        temperatureLabel.text = temperature
    }
    
}
