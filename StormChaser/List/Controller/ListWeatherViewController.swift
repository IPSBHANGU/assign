//
//  ListWeatherViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit
import MapKit

class ListWeatherViewController: UIViewController {

    // MARK: UI Elements
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var weatherDataLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var userClickedImageSlideShow: SlideShowView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var weatherData:WeatherEntryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBarHidden(true, animated: true)
        setupUI()
        setupData()
    }

    func setupUI() {
        titleLable.font = UIFont(name: "Rubik-SemiBold", size: 18)
        cityLabel.font = UIFont(name: "Rubik-Regular", size: 35)
        coordinateLabel.font = UIFont(name: "Rubik-Regular", size: 20)
        coordinateLabel.textColor = .secondaryLabel
        weatherDataLabel.font = UIFont(name: "Rubik-SemiBold", size: 20)
        weatherConditionLabel.font = UIFont(name: "Rubik-SemiBold", size: 22)
        temperatureLabel.font = UIFont(name: "Rubik-Regular", size: 20)
        temperatureLabel.textColor = .secondaryLabel
        userClickedImageSlideShow.layer.cornerRadius = 16
        userClickedImageSlideShow.clipsToBounds = true
        notesLabel.font = UIFont(name: "Rubik-SemiBold", size: 20)
        summaryLabel.font = UIFont(name: "Rubik-Regular", size: 20)
        mapView.layer.cornerRadius = 16
        mapView.clipsToBounds = true
        scrollView.delegate = self
    }
    
    func setupData() {
        guard let weatherData = weatherData else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "d-MMMM-yy hh:mm a"
        formatter.locale = Locale.current
        let dateString = formatter.string(from: weatherData.timestamp)
        let code = weatherData.weatherData.hourly.weatherCode[indexOfClosestDate(to: weatherData.timestamp, in: weatherData.weatherData.hourly.time)]
        let condition = ConditionType.from(weatherCode: code)
        let coordinate = CLLocationCoordinate2D(latitude: weatherData.latitude, longitude: weatherData.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        let location = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        titleLable.text = dateString
        cityLabel.text = weatherData.city
        coordinateLabel.text = "\(weatherData.latitude) , \(weatherData.longitude)"
        weatherConditionLabel.text = condition.description().description
        temperatureLabel.text = String(format: "%.1f°C", weatherData.weatherData.hourly.temperature2m[indexOfClosestDate(to: weatherData.timestamp, in: weatherData.weatherData.hourly.time)])
        userClickedImageSlideShow.images = weatherData.images
        summaryLabel.text = weatherData.summary
        mapView.addAnnotation(annotation)
        mapView.setRegion(location, animated: true)
    }


    @IBAction func backButtonAction(_ sender: Any) {
        self.tabBarController?.setTabBarHidden(false, animated: true)
        self.navigationController?.popViewController(animated: true)
    }

    func indexOfClosestDate(to targetDate: Date, in dates: [Date]) -> Int {
        guard let index = dates.enumerated().min(by: {
            abs($0.element.timeIntervalSince(targetDate)) < abs($1.element.timeIntervalSince(targetDate))
        })?.offset else {
            print("No valid time found.")
            return 0
        }
        return index
    }
}

extension ListWeatherViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Convert submitButton's frame to scrollView's coordinate space
        guard let submitButton = self.mapView else { return }
        let buttonMaxY = scrollView.convert(submitButton.frame, from: submitButton.superview).maxY
        
        // Get visible height of scrollView
        let visibleHeight = scrollView.bounds.height

        // Calculate maximum offset so the bottom of the button is just visible
        let maxOffsetY = buttonMaxY - visibleHeight + 50

        // Restrict scrolling beyond the bottom of the button
        if scrollView.contentOffset.y > maxOffsetY {
            scrollView.contentOffset.y = maxOffsetY
        }
    }
}
