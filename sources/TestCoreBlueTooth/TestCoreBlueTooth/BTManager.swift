//
//  BTManager.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/9.
//

import Foundation
import CoreBluetooth

class BTManager: NSObject {
    var manager: CBCentralManager!
    
    var peripheral: CBPeripheral?
    var RSSI: NSNumber?
    var advertisementData: [String: Any]?
    
    func start() {
        let manager = CBCentralManager()
        manager.delegate = self
        self.manager = manager
    }
    
    private func startScan() {
        self.manager.scanForPeripherals(withServices: nil)
    }
}

extension BTManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScan()
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.RSSI = RSSI
        
        // self.manager.connect(peripheral)
        
        if peripheral.name?.count ?? 0 > 0 {
            print(peripheral, advertisementData, RSSI, separator: "\n")
        }
    }
    
     func centralManager(_ central: CBCentralManager,
                         didConnect peripheral: CBPeripheral) {
         self.peripheral = peripheral
         
     }
     
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension BTManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral.services ?? [], (error as? NSError)?.userInfo as Any)
        
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        for cha in service.characteristics ?? [] {
            peripheral.discoverDescriptors(for: cha)
            peripheral.readValue(for: cha)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverDescriptorsFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        for dis in characteristic.descriptors ?? [] {
            peripheral.readValue(for: dis)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
}
