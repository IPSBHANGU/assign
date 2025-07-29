//
//  NetworkMonitor.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    func isInternetAvailable(timeout: TimeInterval = 2.0, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.google.com") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = timeout

        URLSession(configuration: .default).dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
