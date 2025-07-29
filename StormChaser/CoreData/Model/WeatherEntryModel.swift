//
//  WeatherEntryModel.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 28/07/25.
//

import Foundation
import UIKit
import CoreData

struct WeatherEntryModel {
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    let city: String
    let weatherData: WeatherData
    let images: [UIImage]
    let summary: String
    let uid: String

    // MARK: - Save to CoreData
    func save(to context: NSManagedObjectContext) throws {
        let entry = WeatherEntry(context: context) // this is the NSManagedObject subclass
        entry.timestamp = timestamp
        entry.latitude = latitude
        entry.longitude = longitude
        entry.city = city
        entry.summary = summary
        entry.uid = uid

        // Encode WeatherData
        let weatherDataEncoded = try JSONEncoder().encode(weatherData)
        entry.weatherData = weatherDataEncoded

        // Encode [UIImage] to Data
        let imageDataArray = images.compactMap { $0.pngData() }
        entry.images = try NSKeyedArchiver.archivedData(withRootObject: imageDataArray, requiringSecureCoding: false)

        try context.save()
    }

    // MARK: - Load All Entries
    static func fetchAll(from context: NSManagedObjectContext) throws -> [WeatherEntryModel] {
        let request: NSFetchRequest<WeatherEntry> = WeatherEntry.fetchRequest()
        let results = try context.fetch(request)
        return try results.map { try WeatherEntryModel.fromCoreData($0) }
    }

    // MARK: - Convert from CoreData to Model
    static func fromCoreData(_ object: WeatherEntry) throws -> WeatherEntryModel {
        let weatherDataDecoded = try JSONDecoder().decode(WeatherData.self, from: object.weatherData ?? Data())
        let imageDataArray = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(object.images ?? Data()) as? [Data]) ?? []
        let imageArray = imageDataArray.compactMap { UIImage(data: $0) }

        return WeatherEntryModel(
            timestamp: object.timestamp ?? Date(),
            latitude: object.latitude,
            longitude: object.longitude,
            city: object.city ?? "",
            weatherData: weatherDataDecoded,
            images: imageArray,
            summary: object.summary ?? "",
            uid: object.uid ?? ""
        )
    }
    
    static func delete(_ model: WeatherEntryModel, from context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<WeatherEntry> = WeatherEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "timestamp == %@", model.timestamp as CVarArg)
        fetchRequest.fetchLimit = 1

        if let objectToDelete = try context.fetch(fetchRequest).first {
            context.delete(objectToDelete)
            try context.save()
        }
    }
}

