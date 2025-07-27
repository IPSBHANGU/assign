//
//  WeatherEntry+CoreDataProperties.swift
//  
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//
//

import Foundation
import CoreData


extension WeatherEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntry> {
        return NSFetchRequest<WeatherEntry>(entityName: "WeatherEntry")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var city: String?
    @NSManaged public var weatherData: Data?
    @NSManaged public var images: Data?
    @NSManaged public var summary: String?

}
