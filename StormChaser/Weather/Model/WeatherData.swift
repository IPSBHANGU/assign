//
//  WeatherData.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import Foundation

struct WeatherData: Codable {
    let hourly: Hourly

    struct Hourly: Codable {
        let time: [Date]
        let temperature2m: [Float]
        let windspeed10m: [Float]
        let precipitation: [Float]
        let weatherCode: [Int]
    }
}
