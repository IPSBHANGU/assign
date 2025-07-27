//
//  ListViewController.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: UIElements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var availableWeatherData: [WeatherEntryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCollectionView()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        fetchData()
    }

    func setupUI(){
       titleLabel.font = UIFont(name: "Rubik-SemiBold", size: 18)
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        do {
            let fetchData = try WeatherEntryModel.fetchAll(from: appDelegate.persistentContainer.viewContext)
            availableWeatherData = fetchData
            collectionView.reloadData()
        } catch {
            MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Failed to fetch weather data: \(error)", actions: [
                MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                    MatrialAlertView().dismissAlert()
                })
            ])
        }
    }

    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weatherCell")
        collectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: "AddPhotoCell")
    }

}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableWeatherData.isEmpty ? 1 : availableWeatherData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if availableWeatherData.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCell
            return cell
        } else {
            if indexPath.row == availableWeatherData.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCell
                return cell
            } else {
                let weatherData = availableWeatherData[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell

                let defaultImage = UIImage(systemName: "photo")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
                cell.setupCell(
                    image: weatherData.images.first ?? defaultImage!,
                    city: weatherData.city,
                    temperature: String(format: "%.1f°C", weatherData.weatherData.hourly.temperature2m.first ?? 0.0)
                )
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if availableWeatherData.isEmpty || indexPath.row == availableWeatherData.count {
            let addWeatherVC = AddWeatherDataViewController()
            navigationController?.pushViewController(addWeatherVC, animated: true)
        } else {
            let selectedWeather = availableWeatherData[indexPath.row]
            print("Selected weather: \(selectedWeather.city)")
        }
    }

}
