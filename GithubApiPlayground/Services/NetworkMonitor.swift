//
//  NetworkMonitor.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/30.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    let monitor: NWPathMonitor
    let queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = true

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
