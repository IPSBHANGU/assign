//
//  AddWeatherDataViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit
import CoreData
import CoreLocation
import GrowingTextView

class AddWeatherDataViewController: UIViewController {

    // MARK: UIElements
    @IBOutlet weak var scrollView: UIScrollView!
    private var refreshControl = UIRefreshControl()
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLable: UILabel!
    @IBOutlet weak var precipitationLable: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteTextView: GrowingTextView!
    @IBOutlet weak var submitButton: UIButton!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var weatherData: WeatherData?
    var images: [UIImage] = []
    
    override func viewIsAppearing(_ animated: Bool) {
        imageView.alpha = 0
        noteTextView.alpha = 0
        submitButton.alpha = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Do any additional setup after loading the view.
        setupUI()
        setupLocationManager()
        setupRefreshControl()
        setupImageView()
        setupTextView()
    }
    
    func setupUI(){
        titleLabel.font = UIFont(name: "Rubik-SemiBold", size: 20)
        submitButton.titleLabel?.font = UIFont(name: "Rubik-SemiBold", size: 15)
        submitButton.setTitle("+ Add Weather Data", for: .normal)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        scrollView.isScrollEnabled = true                      // Allow gesture
        scrollView.alwaysBounceVertical = true                 // Force vertical bounce
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        scrollView.delegate = self
    }

    func setupImageView() {
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tap)
    }
    
    func setupTextView() {
        noteTextView.maxLength = 140
        noteTextView.trimWhiteSpaceWhenEndEditing = false
        noteTextView.placeholder = "Add a note..."
        noteTextView.placeholderColor = UIColorHex().hexStringToUIColor(hex: "#C5C6CC")
        noteTextView.minHeight = 25.0
        noteTextView.maxHeight = 270.0
        noteTextView.backgroundColor = .systemBackground
        noteTextView.layer.cornerRadius = 8
        noteTextView.layer.masksToBounds = true
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#C5C6CC").cgColor
        noteTextView.delegate = self
    }
    
    @objc private func refreshPulled() {
        locationManager.requestLocation()
        imageView.alpha = 0
        noteTextView.alpha = 0
        submitButton.alpha = 0
    }
    
    @objc func imageViewTapped() {
        let galleryVC = PhotoGalleryViewController()
        galleryVC.modalPresentationStyle = .popover
        galleryVC.delegate = self
        galleryVC.images = images
        present(galleryVC, animated: true)
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let weatherData else {
            MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Please try again later.", actions: [MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                MatrialAlertView().dismissAlert()
            })])
            return
        }
        let currentData = WeatherEntryModel(
            timestamp: Date(),
            latitude: 30.7333,
            longitude: 76.7794,
            city: "Chandigarh",
            weatherData: weatherData,
            images: images,
            summary: "Cloudy with some showers"
        )
        
        do {
            try currentData.save(to: appDelegate.persistentContainer.viewContext)
            self.navigationController?.popViewController(animated: true)
        } catch {
            MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Failed to save entry: \(error)", actions: [MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                MatrialAlertView().dismissAlert()
            })])
        }
    }
    
}

extension AddWeatherDataViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        Task {
            do {
                weatherData = try await WeatherService.shared.fetchWeather(for: location)

                guard let weatherData = weatherData else {
                    print("No weather data found.")
                    return
                }
                
                let now = Date()
                let times = weatherData.hourly.time

                // Find the closest time index
                guard let closestIndex = times.enumerated().min(by: {
                    abs($0.element.timeIntervalSince(now)) < abs($1.element.timeIntervalSince(now))
                })?.offset else {
                    print("No valid time found.")
                    return
                }

                let dateFormatter = DateFormatter()
                let locale = Locale.current
                let is24Hour = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)?.contains("a") == false
                dateFormatter.timeZone = .current
                dateFormatter.dateFormat = is24Hour ? "yyyy-MM-dd HH:mm" : "yyyy-MM-dd hh:mm a"

                let time = dateFormatter.string(from: times[closestIndex])
                let temperature = weatherData.hourly.temperature2m[closestIndex]
                let windSpeed = weatherData.hourly.windspeed10m[closestIndex]
                let precipitation = weatherData.hourly.precipitation[closestIndex]
                let code = weatherData.hourly.weatherCode[closestIndex]
                let condition = ConditionType.from(weatherCode: code)
                let (desc, icon, tint) = condition.description()

                temperatureLabel.text = String(format: "%.1f°C", temperature)
                windSpeedLable.text = "Wind Speed: \(String(format: "%.1.f m/s", windSpeed))"
                precipitationLable.text = "Precipitation: \(String(format: "%.1.f mm", precipitation))"
                weatherImage.image = icon
                weatherImage.tintColor = tint
                weatherDescriptionLabel.text = desc
                imageView.alpha = 1
                noteTextView.alpha = 1
                submitButton.alpha = 1
                
                locationManager.stopUpdatingLocation()
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let error = error {
                        MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Location error: \(error.localizedDescription)", actions: [MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                            MatrialAlertView().dismissAlert()
                        })])
                        return
                    }

                    if let placemark = placemarks?.first {
                        let city = placemark.locality ?? ""

                        self.cityLabel.text = city
                    }
                }
                
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }

            } catch {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Weather fetch failed: \(error.localizedDescription)", actions: [MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                        MatrialAlertView().dismissAlert()
                    })])
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.refreshControl.endRefreshing()
        MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Location error: \(error.localizedDescription)", actions: [MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
            MatrialAlertView().dismissAlert()
        })])
    }
}

extension AddWeatherDataViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
       UIView.animate(withDuration: 0.2) {
           self.view.layoutIfNeeded()
       }
    }
}

extension AddWeatherDataViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Allow downward scrolling for pull-to-refresh
//        if scrollView.contentOffset.y > 0 {
//            scrollView.contentOffset.y = 0
//        }
    }
}

extension AddWeatherDataViewController: PhotoGalleryViewControllerDelegate {
    func photoGallery(_ controller: PhotoGalleryViewController, didFinishPicking images: [UIImage]) {
        print(images.count)
        self.images.append(contentsOf: images)
    }
    
}
