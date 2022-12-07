//  INFO49635 - CAPSTONE FALL 2022
//  NetworkMonitor.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import Network

//class used to check internet connectivity status of the device

final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    
    init(){
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        
        monitor.start(queue: queue)
    }
}
