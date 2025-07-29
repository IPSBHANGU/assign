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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    var startFrame: CGRect?
    var coordinates: CLLocationCoordinate2D?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.30) {
            self.mapView.transform = .identity
            
            UIView.animate(withDuration: 0.30) {
                self.backgroundView.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        setupUI()
    }

    func setupUI() {
        guard let startFrame = startFrame else {return}
        mapView.transform = CGAffineTransform(from: mapView.frame, to: startFrame)
        mapView.layer.cornerRadius = 12
        mapView.layer.masksToBounds = true
    }
    
    func setupMapView(){
        guard let coordinates = coordinates else {return}
        mapView.showsUserLocation = true
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        let location = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.addAnnotation(annotation)
        mapView.setRegion(location, animated: true)
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        guard let startFrame = startFrame else {return}
        UIView.animate(withDuration: 0.30) {
            self.mapView.transform = CGAffineTransform(from: self.mapView.frame, to: startFrame)
            self.backgroundView.alpha = 0
            self.backButton.alpha = 0
            self.mapView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
