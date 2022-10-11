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
}

extension BTPeriperalManager: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // simulator: rawValue: 2, unsupported
        // device: rawValue: 5, poweredOn
        print(peripheral.state.rawValue)
    }
}
