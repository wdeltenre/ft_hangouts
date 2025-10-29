//
//  NetworkMonitor.swift
//  ft_hangouts
//
//  Created by William Deltenre on 25/10/2025.
//

import Network
import Foundation
import Combine

final class NetworkMonitor: ObservableObject {
    private var isMonitoring: Bool = false
    
    @Published var isConnected: Bool = true
    
    var monitor: NWPathMonitor?
    
    init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let newStatus = path.status == .satisfied
                
                if self.isConnected != newStatus {
                    self.isConnected = newStatus
                    print("Network status updated: \(newStatus ? "CONNECTED" : "DISCONNECTED")")
                }
            }
        }
        
        self.isMonitoring = true
    }
    
    public func stopMonitoring() {
           guard isMonitoring, let monitor = monitor else { return }
           monitor.cancel()
           self.monitor = nil
           isMonitoring = false
       }
}
