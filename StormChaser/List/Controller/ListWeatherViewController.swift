//
//  ListWeatherViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit

class ListWeatherViewController: UIViewController {

    // MARK: UI Elements
    @IBOutlet weak var titleLable: UILabel!
    
    var weatherData:WeatherEntryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBarHidden(true, animated: true)
        setupUI()
        setupData()
    }

    func setupUI() {
        titleLable.font = UIFont(name: "Rubik-SemiBold", size: 20)
    }
    
    func setupData() {
        guard let weatherData = weatherData else { return }
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MMMM-yy hh:mm a"
        formatter.locale = Locale.current
        let dateString = formatter.string(from: weatherData.timestamp)
        titleLable.text = dateString
    }


    @IBAction func backButtonAction(_ sender: Any) {
        self.tabBarController?.setTabBarHidden(false, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
}
