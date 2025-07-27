//
//  MapViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: UI Elements
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        checkLocationAuthorization()
    }

    func setupMapView(){
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .adaptive
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(compassButton)
        NSLayoutConstraint.activate([
            compassButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50),
            compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16)
        ])
    }
    
    func checkLocationAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            let openSettingsAction = MaterialAlertAction(title: "Open Settings", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1")) {
                if let appSettings = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            MatrialAlertView().showAlert(viewController: self, title: "Location Access Needed", message: "Please enable location access in Settings to use this feature.", actions: [openSettingsAction])
            
        @unknown default:
            break
        }
    }
    
    @IBAction func handleAddAction(_ sender: Any) {
        let addWeatherVC = AddWeatherDataViewController()
        self.navigationController?.pushViewController(addWeatherVC, animated: true)
    }

    @IBAction func handleSettingsAction(_ sender: Any) {
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}
