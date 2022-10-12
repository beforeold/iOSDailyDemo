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
    
    let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? ""
    // print("peripherial local name: \(localName)")
    
    guard localName.hasPrefix("bud.") else {
      return
    }
    
    let line = "==============================="
    print(line)
    print("didDiscover peripheral")
    print(localName,
          peripheral.name ?? "null",
          advertisementData,
          RSSI,
          "",
          separator: "\n",
          terminator: line + "\n\n")
    
    manager.stopScan()
    manager.connect(peripheral)
  }
  
  func centralManager(_ central: CBCentralManager,
                      didConnect peripheral: CBPeripheral) {
    print("didConnect peripheral: \(peripheral.name ?? "null")")
    
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
    let services = peripheral.services ?? []
    // print("didDiscoverServices")
    print("didDiscoverServices", services.map(\.readableDesc), info(of: error))
    
    let serviceUUIDStrings = [CBUUID.Service.data, .Service.notify].map(\.uuidString)
    for service in services where serviceUUIDStrings.contains(service.uuid.uuidString) {
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    print("didModifyServices")
  }
  
  func peripheral(_ peripheral: CBPeripheral,
                  didDiscoverCharacteristicsFor service: CBService,
                  error: Error?) {
    let chars = service.characteristics ?? []
    
    print("service: \(service.readableDesc)",
          "didDiscoverCharacteristics \(chars.map(\.readableDesc))",
          info(of: error))
    
    for cha in chars {
      peripheral.discoverDescriptors(for: cha)
      if cha.properties.contains(.read) {
        peripheral.readValue(for: cha)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral,
                  didDiscoverDescriptorsFor characteristic: CBCharacteristic,
                  error: Error?) {
    let descriptors = characteristic.descriptors ?? []
    
    print("char: \(characteristic.readableDesc), didDiscoverDescriptors \(descriptors.map(\.readableDesc))", info(of: error))
    
    for dis in descriptors {
      guard dis.readableDesc.contains("bud.") else {
        continue
      }
      peripheral.readValue(for: dis)
    }
  }
  
  // MARK: - Did Update Value
  func peripheral(_ peripheral: CBPeripheral,
                  didUpdateValueFor characteristic: CBCharacteristic,
                  error: Error?) {
    print("didUpdateValueFor characteristic \(characteristic.readableDesc) value: ",
          characteristic.value.flatMap { String(data: $0, encoding: .utf8)} ?? "null",
          info(of: error))
  }
  
  func peripheral(_ peripheral: CBPeripheral,
                  didUpdateValueFor descriptor: CBDescriptor,
                  error: Error?) {
    print("didUpdateValueFor descriptor \(descriptor.readableDesc) value: ", descriptor.value as? String ?? "null",
          info(of: error))
  }
}
