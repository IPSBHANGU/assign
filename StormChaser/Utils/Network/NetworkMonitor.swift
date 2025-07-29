//
//  NetworkMonitor.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 29/07/25.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    func isInternetAvailable() -> Bool {
        return isConnected
    }
}
