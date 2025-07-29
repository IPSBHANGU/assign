//
//  FirebaseModel.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import UIKit
import FirebaseDatabaseInternal
import FirebaseStorage

class FirebaseModel:NSObject {
    
    let database = Database.database()
    
    func saveWeatherData(weatherData: WeatherEntryModel, completionHandler: @escaping (_ error: String?) -> Void) {
        let weatherEntry = database.reference().child("weather_entries").child(weatherData.uuid)
        
        let handleDataUpload: (_ imageUrls: [String]) -> Void = { imageUrls in
            let hourly = weatherData.weatherData.hourly
            let timeIntervals = hourly.time.map { $0.timeIntervalSince1970 }

            let dataDict: [String: Any] = [
                "timestamp": weatherData.timestamp.timeIntervalSince1970,
                "latitude": weatherData.latitude,
                "longitude": weatherData.longitude,
                "city": weatherData.city,
                "summary": weatherData.summary,
                "uid": weatherData.uid,
                "uuid": weatherData.uuid,
                "imageUrls": imageUrls,
                "weatherData": [
                    "hourly": [
                        "time": timeIntervals,
                        "temperature2m": hourly.temperature2m,
                        "windspeed10m": hourly.windspeed10m,
                        "precipitation": hourly.precipitation,
                        "weatherCode": hourly.weatherCode
                    ]
                ]
            ]

            weatherEntry.setValue(dataDict) { error, _ in
                if let error = error {
                    completionHandler(error.localizedDescription)
                } else {
                    completionHandler(nil)
                }
            }
        }

        if let images = weatherData.images, !images.isEmpty {
            self.uploadImages(images, toPath: weatherData.uuid) { urls, error in
                if let error = error {
                    completionHandler(error.localizedDescription)
                } else {
                    handleDataUpload(urls?.map { $0.absoluteString } ?? [])
                }
            }
        } else {
            handleDataUpload([]) // No images to upload
        }
    }
    
    private func uploadImages(_ images: [UIImage], toPath path: String, completion: @escaping (_ urls: [URL]?, _ error: Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(path)
        
        var uploadedURLs: [URL] = Array(repeating: URL(string: "placeholder")!, count: images.count)
        var uploadCount = 0
        var failed = false
        
        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(nil, NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"]))
                return
            }
            
            let imageRef = storageRef.child("image_\(index).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    if !failed {
                        failed = true
                        completion(nil, error)
                    }
                    return
                }
                
                imageRef.downloadURL { url, error in
                    if let error = error {
                        if !failed {
                            failed = true
                            completion(nil, error)
                        }
                        return
                    }
                    
                    if let url = url {
                        uploadedURLs[index] = url
                        uploadCount += 1
                        
                        if uploadCount == images.count && !failed {
                            completion(uploadedURLs, nil)
                        }
                    }
                }
            }
        }
    }
    
    func deleteWeatherEntry(weatherData: WeatherEntryModel, completion: @escaping (_ error: String?) -> Void) {
        let uuid = weatherData.uuid
        let imageURLs = weatherData.imageURLs
        let dbRef = database.reference().child("weather_entries").child(uuid)
        
        dbRef.removeValue { error, _ in
            if let error = error {
                completion("Failed to delete entry: \(error.localizedDescription)")
                return
            }
            
            // Delete images from Firebase Storage if they exist
            guard let imageURLs = imageURLs, !imageURLs.isEmpty else {
                completion(nil)
                return
            }
            
            let storage = Storage.storage()
            let dispatchGroup = DispatchGroup()
            var deletionError: String?
            
            for urlString in imageURLs {
                if let url = URL(string: urlString) {
                    let ref = storage.reference(forURL: url.absoluteString)
                    dispatchGroup.enter()
                    ref.delete { error in
                        if let error = error {
                            deletionError = "Failed to delete some images: \(error.localizedDescription)"
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(deletionError)
            }
        }
    }

    func fetchAllWeatherEntries(completion: @escaping (_ entries: [WeatherEntryModel]?, _ error: String?) -> Void) {
        let ref = database.reference().child("weather_entries")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion([], nil)
                return
            }
            
            var entries: [WeatherEntryModel] = []
            
            for (_, entryValue) in value {
                if let entryData = entryValue as? [String: Any],
                   let timestamp = entryData["timestamp"] as? TimeInterval,
                   let latitude = entryData["latitude"] as? Double,
                   let longitude = entryData["longitude"] as? Double,
                   let city = entryData["city"] as? String,
                   let summary = entryData["summary"] as? String,
                   let uid = entryData["uid"] as? String,
                   let uuid = entryData["uuid"] as? String,
                   let weatherDataDict = entryData["weatherData"] as? [String: Any],
                   let hourlyDict = weatherDataDict["hourly"] as? [String: Any],
                   let timeArr = hourlyDict["time"] as? [TimeInterval],
                   let temperatureArr = hourlyDict["temperature2m"] as? [Float],
                   let windspeedArr = hourlyDict["windspeed10m"] as? [Float],
                   let precipitationArr = hourlyDict["precipitation"] as? [Float],
                   let weatherCodeArr = hourlyDict["weatherCode"] as? [Int]
                {
                    let time = timeArr.map { Date(timeIntervalSince1970: $0) }
                    
                    let hourly = WeatherData.Hourly(
                        time: time,
                        temperature2m: temperatureArr,
                        windspeed10m: windspeedArr,
                        precipitation: precipitationArr,
                        weatherCode: weatherCodeArr
                    )
                    
                    let weatherData = WeatherData(hourly: hourly)
                    let imageURLs = entryData["imageUrls"] as? [String]
                    
                    let model = WeatherEntryModel(
                        timestamp: Date(timeIntervalSince1970: timestamp),
                        latitude: latitude,
                        longitude: longitude,
                        city: city,
                        weatherData: weatherData,
                        images: nil,
                        summary: summary,
                        uid: uid,
                        uuid: uuid,
                        imageURLs: imageURLs
                    )
                    
                    entries.append(model)
                }
            }
            
            completion(entries, nil)
        } withCancel: { error in
            completion(nil, error.localizedDescription)
        }
    }
}
