//
//  BTPeriperalManager.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/11.
//

import Foundation
import CoreBluetooth

class BTPeriperalManager: NSObject {
    
    private var manager: CBPeripheralManager!
    
    func start() {
        manager = CBPeripheralManager()
        manager.delegate = self
    }
    
    fileprivate func addServices(_ services: [CBMutableService]) {
        services.forEach(manager.add)
    }
    
    fileprivate func createServices() -> [CBMutableService] {
        let service = CBMutableService(type: .init(string: "FFE0"),
                                       primary: true)
        
        return [service]
    }
}

extension BTPeriperalManager: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // simulator: rawValue: 2, unsupported
        // device: rawValue: 5, poweredOn
        print(peripheral.state.rawValue)
        
        if manager.state == .poweredOn {
            addServices([])
        }
    }
}
