//
//  BTPeriperalManager.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/11.
//

import Foundation
import CoreBluetooth

extension CBUUID {
  enum Service {
    static let data = CBUUID(string: "FFE0")
    static let notify = CBUUID(string: "FFE1")
  }
  
  enum Char {
    static let read = CBUUID(string: "FFE2")
    static let readWrite = CBUUID(string: "FFE3")
    static let notify = CBUUID(string: "FFE4")
  }
  
  enum DescUUID {
    static let desc = CBUUID(string: CBUUIDCharacteristicUserDescriptionString)
  }
}

class BTPeriperalManager: NSObject {
  
  private var manager: CBPeripheralManager!
  
  func start() {
    manager = CBPeripheralManager()
    manager.delegate = self
  }
  
  private func startAdvertising() {
    let services = createServices()
    services.forEach {
      manager.add($0)
    }
    
    // CBAdvertisementDataServiceDataKey not allowed
    let keyValues = services.map { ($0.uuid, $0.uuid.uuidString.data(using: .utf8)!) }
    let servicesData = Dictionary(uniqueKeysWithValues: keyValues)
    _ = [CBAdvertisementDataServiceDataKey: servicesData]
    
    let data: [String: Any] = [
      CBAdvertisementDataLocalNameKey: "bo.periperal",
      CBAdvertisementDataServiceUUIDsKey: services.map(\.self.uuid),
    ]
    manager.startAdvertising(data)
  }
  
  private func createServices() -> [CBMutableService] {
    return [createDataService(), createNotifyService()]
  }
  
  private func createNotifyService() -> CBMutableService {
    let service = CBMutableService(type: .Service.notify, primary: true)
    
    do {
      // let data = "bo.notify.notify.charValue".data(using: .utf8)
      let char = CBMutableCharacteristic(type: .Char.notify,
                                         properties: .notify,
                                         value: nil,
                                         permissions: [.readable, .writeable])
      service.characteristics = [char] + (service.characteristics ?? [])
    }
    
    return service
  }
  
  private func createDataService() -> CBMutableService {
    let service = CBMutableService(type: .Service.data,
                                   primary: true)
    
    do {
      let data = "bo.data.read.charValue".data(using: .utf8)
      let char = CBMutableCharacteristic(type: .Char.read,
                                         properties: .read,
                                         value: data,
                                         permissions: .readable)
      
      let desc = "bo.data.read.descValue"
      let descriptor = CBMutableDescriptor(type: .DescUUID.desc,
                                           value: desc)
      char.descriptors = [descriptor] + (char.descriptors ?? [])
      
      service.characteristics = [char] + (service.characteristics ?? [])
    }
    
    do {
      // let data = "bo.data.readWrite".data(using: .utf8)
      let char = CBMutableCharacteristic(type: .Char.readWrite,
                                         properties: [CBCharacteristicProperties.read, .write],
                                         value: nil,
                                         permissions: [.readable, .writeable])
      service.characteristics = [char] + (service.characteristics ?? [])
    }
    
    return service
  }
}

extension BTPeriperalManager: CBPeripheralManagerDelegate {
  public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    // simulator: rawValue: 2, unsupported
    // device: rawValue: 5, poweredOn
    print(peripheral.state.rawValue)
    
    if manager.state == .poweredOn {
      startAdvertising()
    }
  }
  
  func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager,
                                            error: Error?) {
    print(#function, error as Any)
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
    print("did add service", service)
  }
}
