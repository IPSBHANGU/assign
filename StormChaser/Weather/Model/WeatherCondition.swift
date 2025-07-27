//
//  WeatherCondition.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import UIKit
import CoreLocation

enum ConditionType: String, Codable {
    case clear
    case partlyCloudy
    case cloudy
    case overcast
    case fog
    case drizzle
    case rain
    case heavyRain
    case freezingRain
    case snow
    case heavySnow
    case thunderstorm
    case hail
    case sleet
    case dust
    case sandstorm
    case tornado
    case hurricane
    case unknown

    /// Maps Open-Meteo weathercode to a ConditionType
    static func from(weatherCode code: Int) -> ConditionType {
        switch code {
        case 0:
            return .clear
        case 1:
            return .partlyCloudy
        case 2:
            return .cloudy
        case 3:
            return .overcast
        case 45, 48:
            return .fog
        case 51, 53, 55:
            return .drizzle
        case 61, 63:
            return .rain
        case 65, 82:
            return .heavyRain
        case 66, 67:
            return .freezingRain
        case 71, 73:
            return .snow
        case 75, 85, 86:
            return .heavySnow
        case 95:
            return .thunderstorm
        case 96, 99:
            return .hail
        default:
            return .unknown
        }
    }

    /// Returns a description and icon for the condition
    func description() -> (description: String, image: UIImage?, color: UIColor) {
        let colorHex = UIColorHex()

        switch self {
        case .clear:
            return ("Clear", UIImage(systemName: "sun.max.fill"), colorHex.hexStringToUIColor(hex: "#87CEEB")) // Sky blue
        case .partlyCloudy:
            return ("Partly Cloudy", UIImage(systemName: "cloud.sun.fill"), colorHex.hexStringToUIColor(hex: "#B0C4DE")) // Light steel blue
        case .cloudy:
            return ("Cloudy", UIImage(systemName: "cloud.fill"), colorHex.hexStringToUIColor(hex: "#A9A9A9")) // Dark gray
        case .overcast:
            return ("Overcast", UIImage(systemName: "smoke.fill"), colorHex.hexStringToUIColor(hex: "#696969")) // Dim gray
        case .fog:
            return ("Fog", UIImage(systemName: "cloud.fog.fill"), colorHex.hexStringToUIColor(hex: "#C0C0C0")) // Silver
        case .drizzle:
            return ("Drizzle", UIImage(systemName: "cloud.drizzle.fill"), colorHex.hexStringToUIColor(hex: "#AFEEEE")) // Pale turquoise
        case .rain:
            return ("Rain", UIImage(systemName: "cloud.rain.fill"), colorHex.hexStringToUIColor(hex: "#4682B4")) // Steel blue
        case .heavyRain:
            return ("Heavy Rain", UIImage(systemName: "cloud.heavyrain.fill"), colorHex.hexStringToUIColor(hex: "#2F4F4F")) // Dark slate gray
        case .freezingRain:
            return ("Freezing Rain", UIImage(systemName: "cloud.sleet.fill"), colorHex.hexStringToUIColor(hex: "#00CED1")) // Dark turquoise
        case .snow:
            return ("Snow", UIImage(systemName: "cloud.snow.fill"), colorHex.hexStringToUIColor(hex: "#FFFAFA")) // Snow white
        case .heavySnow:
            return ("Heavy Snow", UIImage(systemName: "snow"), colorHex.hexStringToUIColor(hex: "#F8F8FF")) // Ghost white
        case .thunderstorm:
            return ("Thunderstorm", UIImage(systemName: "cloud.bolt.rain.fill"), colorHex.hexStringToUIColor(hex: "#778899")) // Light slate gray
        case .hail:
            return ("Hail", UIImage(systemName: "cloud.hail.fill"), colorHex.hexStringToUIColor(hex: "#D3D3D3")) // Light gray
        case .sleet:
            return ("Sleet", UIImage(systemName: "cloud.sleet.fill"), colorHex.hexStringToUIColor(hex: "#B0E0E6")) // Powder blue
        case .dust:
            return ("Dust", UIImage(systemName: "sun.dust.fill"), colorHex.hexStringToUIColor(hex: "#DEB887")) // Burlywood
        case .sandstorm:
            return ("Sandstorm", UIImage(systemName: "aqi.medium"), colorHex.hexStringToUIColor(hex: "#EDC9AF")) // Desert sand
        case .tornado:
            return ("Tornado", UIImage(systemName: "tornado"), colorHex.hexStringToUIColor(hex: "#808080")) // Gray
        case .hurricane:
            return ("Hurricane", UIImage(systemName: "hurricane"), colorHex.hexStringToUIColor(hex: "#191970")) // Midnight blue
        case .unknown:
            return ("Unknown", UIImage(systemName: "questionmark.circle.fill"), colorHex.hexStringToUIColor(hex: "#DCDCDC")) // Gainsboro
        }
    }
}
