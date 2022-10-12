//
//  BTCentralManager.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/9.
//

import Foundation
import CoreBluetooth

class BTCentralManager: NSObject {
  var manager: CBCentralManager!
  
  var peripheral: CBPeripheral?
  var RSSI: NSNumber?
  var advertisementData: [String: Any]?
  
  func start() {
    if manager != nil {
      return
    }
    
    let manager = CBCentralManager()
    manager.delegate = self
    self.manager = manager
  }
  
  private func startScan() {
    self.manager.scanForPeripherals(withServices: nil)
  }
}

extension BTCentralManager: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    print("central state: ", central.state.rawValue)
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
    
    let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
    if localName?.hasPrefix("bo") ?? false {
      print("didDiscover peripheral")
      
      print(localName!,
            peripheral.name ?? "null",
            peripheral,
            advertisementData,
            RSSI,
            separator: "\n",
            terminator: "=================\n\n")
      manager.stopScan()
      manager.connect(peripheral)
    }
  }
  
  func centralManager(_ central: CBCentralManager,
                      didConnect peripheral: CBPeripheral) {
    print("didConnect peripheral")
    
    self.peripheral = peripheral
    
    // discover service
    peripheral.delegate = self
    peripheral.discoverServices(nil)
  }
  
  func centralManager(_ central: CBCentralManager,
                      didDisconnectPeripheral peripheral: CBPeripheral,
                      error: Error?) {
    print("didDisconnectPeripheral peripheral")
  }
}

extension BTCentralManager: CBPeripheralDelegate {
  // MARK: - Did Discover
  func peripheral(_ peripheral: CBPeripheral,
                  didDiscoverServices error: Error?) {
    print("didDiscoverServices")
    print(peripheral.services ?? [], (error as? NSError)?.userInfo as Any)
    
    for service in peripheral.services ?? [] {
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral,
                  didDiscoverCharacteristicsFor service: CBService,
                  error: Error?) {
    print("didDiscoverCharacteristicsFor")
    for cha in service.characteristics ?? [] {
      peripheral.discoverDescriptors(for: cha)
      peripheral.readValue(for: cha)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral,
                  didDiscoverDescriptorsFor characteristic: CBCharacteristic,
                  error: Error?) {
    print("didDiscoverDescriptorsFor")
    for dis in characteristic.descriptors ?? [] {
      peripheral.readValue(for: dis)
    }
  }
  
  // MARK: - Did Update Value
  func peripheral(_ peripheral: CBPeripheral,
                  didUpdateValueFor characteristic: CBCharacteristic,
                  error: Error?) {
    print("didUpdateValueFor characteristic")
    print("characteristic value: ", characteristic.value.flatMap { String(data: $0, encoding: .utf8)} ?? "null")
  }
  
  func peripheral(_ peripheral: CBPeripheral,
                  didUpdateValueFor descriptor: CBDescriptor,
                  error: Error?) {
    print("didUpdateValueFor descriptor")
    print("descriptor value: ", descriptor.value as? String ?? "null")
  }
}
