//
//  ListWeatherViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit
import MapKit
import CoreData
import FirebaseAuth

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
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var weatherData:WeatherEntryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBarHidden(true, animated: true)
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
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
        userClickedImageSlideShow.delegate = self
        notesLabel.font = UIFont(name: "Rubik-SemiBold", size: 20)
        summaryLabel.font = UIFont(name: "Rubik-Regular", size: 20)
        mapView.layer.cornerRadius = 16
        mapView.clipsToBounds = true
        scrollView.delegate = self
        deleteButton.titleLabel?.font = UIFont(name: "Rubik-SemiBold", size: 18)
        NetworkMonitor.shared.isInternetAvailable { (isOnline) in
            if isOnline {
                DispatchQueue.main.async {
                    self.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomMap)))
                }
            } else {
                DispatchQueue.main.async {
                    self.mapView.isHidden = true
                    let noInternetLabel: UILabel = {
                        let label = UILabel()
                        label.text = "Connect to Internet for MapView"
                        label.textColor = .placeholderText
                        label.textAlignment = .center
                        label.font = UIFont(name: "Rubik-SemiBold", size: 20)
                        return label
                    }()
                    self.scrollView.addSubview(noInternetLabel)
                    noInternetLabel.frame = self.mapView.frame
                }
            }
        }
        if weatherData?.uid != Auth.auth().currentUser?.uid {
            deleteButton.removeFromSuperview()
        }
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
        userClickedImageSlideShow.uiImages = weatherData.images
        userClickedImageSlideShow.urlImages = weatherData.imageURLs
        if weatherData.summary == "" {
            summaryLabel.text = "No notes available"
        } else {
            summaryLabel.text = weatherData.summary
        }
        NetworkMonitor.shared.isInternetAvailable { (isOnline) in
            if isOnline {
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setRegion(location, animated: true)
                }
            }
        }
    }


    @IBAction func backButtonAction(_ sender: Any) {
        self.tabBarController?.setTabBarHidden(false, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let weatherData = weatherData else { return }
        
        // Show loading overlay
        let loadingOverlay = LoadingOverlayView(on: self)
        loadingOverlay.start()
        
        FirebaseModel().deleteWeatherEntry(weatherData: weatherData) { error in
            if let error = error {
                loadingOverlay.stop()
                MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Failed to delete weather data: \(error)", actions: [
                    MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                        MatrialAlertView().dismissAlert()
                    })
                ])
            } else {
                do {
                    loadingOverlay.stop()
                    try WeatherEntryModel.delete(weatherData, from: appDelegate.persistentContainer.viewContext)
                    self.tabBarController?.setTabBarHidden(false, animated: true)
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    loadingOverlay.stop()
                    MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Failed to delete weather data: \(error)", actions: [
                        MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                            MatrialAlertView().dismissAlert()
                        })
                    ])
                }
            }
        }
    }
    
    @objc func zoomMap() {
        guard let weatherData = weatherData else { return }
        let mapViewController = MapViewController()
        mapViewController.startFrame = self.mapView.frame
        mapViewController.coordinates = CLLocationCoordinate2D(latitude: weatherData.latitude, longitude: weatherData.longitude)
        mapViewController.modalPresentationStyle = .overFullScreen
        present(mapViewController, animated: false, completion: nil)
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

extension ListWeatherViewController: SlideShowViewDelegate {
    func didSelect(_ isURL: Bool, didSelectItemAt indexPath: IndexPath) {
        print(isURL, indexPath.row)
        let imageVC = ImageViewController()
        if let urls = weatherData?.imageURLs, !urls.isEmpty {
            imageVC.useURL = true
            imageVC.imageURL = URL(string: urls[indexPath.row])
        } else if let imgs = weatherData?.images, !imgs.isEmpty {
            imageVC.useURL = false
            imageVC.image = imgs[indexPath.row]
        }
        imageVC.startFrame = self.userClickedImageSlideShow.frame
        imageVC.modalPresentationStyle = .overFullScreen
        self.present(imageVC, animated: false)
    }
}
