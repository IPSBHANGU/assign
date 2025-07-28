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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var availableWeatherData: [WeatherEntryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        fetchData()
    }

    func setupUI(){
       titleLabel.font = UIFont(name: "Rubik-SemiBold", size: 32)
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        do {
            let fetchData = try WeatherEntryModel.fetchAll(from: appDelegate.persistentContainer.viewContext)
            availableWeatherData = fetchData
            tableView.reloadData()
        } catch {
            MatrialAlertView().showAlert(viewController: self, title: "Error", message: "Failed to fetch weather data: \(error)", actions: [
                MaterialAlertAction(title: "Okay", titleColor: UIColorHex().hexStringToUIColor(hex: "#554d56"), backgroundColor: UIColorHex().hexStringToUIColor(hex: "#c1bec1"), handler: {
                    MatrialAlertView().dismissAlert()
                })
            ])
        }
    }

    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
    }
    
    
    @IBAction func addButtonAction(_ sender: Any) {
        let addWeatherVC = AddWeatherDataViewController()
        navigationController?.pushViewController(addWeatherVC, animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        availableWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let weatherData = availableWeatherData[indexPath.row]
        let defaultImage = UIImage(systemName: "photo")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        let now = Date()

        func indexOfClosestDate(to targetDate: Date, in dates: [Date]) -> Int {
            guard let index = dates.enumerated().min(by: {
                abs($0.element.timeIntervalSince(targetDate)) < abs($1.element.timeIntervalSince(targetDate))
            })?.offset else {
                print("No valid time found.")
                return 0
            }
            return index
        }
        
        let condition = ConditionType.from(weatherCode: weatherData.weatherData.hourly.weatherCode[indexOfClosestDate(to: now, in: weatherData.weatherData.hourly.time)])
        cell.setupCell(image: weatherData.images.first ?? defaultImage!, location: weatherData.city, weatherCondition: condition.description().description, temperature: String(format: "%.1f°C", weatherData.weatherData.hourly.temperature2m.first ?? 0.0))
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listWeatherVC = ListWeatherViewController()
        listWeatherVC.weatherData = availableWeatherData[indexPath.row]
        self.navigationController?.pushViewController(listWeatherVC, animated: true)
    }
    
}
