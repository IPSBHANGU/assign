//
//  WeatherService.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import Foundation
import CoreLocation
import OpenMeteoSdk

class WeatherService: NSObject {
    /// Based-Upon documentation from https://open-meteo.com/en/docs
    
    static let shared = WeatherService()
    
    /// Fetches weather data for a given CLLocation
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // API URL with hourly variables maped as in WeatherData
        guard let url = URL(string:
            "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,windspeed_10m,precipitation,weathercode&format=flatbuffers"
        ) else {
            throw URLError(.badURL)
        }
        
        // Fetch weather data using OpenMeteoSdk
        let responses = try await WeatherApiResponse.fetch(url: url)
        guard let response = responses.first else {
            throw NSError(domain: "WeatherService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Empty response"])
        }
        
        let offset = response.utcOffsetSeconds
        guard let hourly = response.hourly else {
            throw NSError(domain: "WeatherService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Missing hourly data"])
        }
        
        // Get time array
        let time = hourly.getDateTime(offset: offset)
        
        guard
            let temperatureVar = hourly.variables(at: 0),
            let windspeedVar = hourly.variables(at: 1),
            let precipitationVar = hourly.variables(at: 2),
            let weatherCodeVar = hourly.variables(at: 3)
        else {
            throw NSError(domain: "WeatherService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Missing variables"])
        }
        
        return WeatherData(hourly: .init(
            time: time,
            temperature2m: temperatureVar.values,
            windspeed10m: windspeedVar.values,
            precipitation: precipitationVar.values,
            weatherCode: weatherCodeVar.values.map { Int($0) }
        ))
    }
}
