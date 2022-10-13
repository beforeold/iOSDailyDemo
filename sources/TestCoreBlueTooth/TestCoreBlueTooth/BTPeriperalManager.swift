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
  
  private var timer: Timer?
  
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
      CBAdvertisementDataLocalNameKey: "bud.periperal",
      CBAdvertisementDataServiceUUIDsKey: services.map(\.uuid),
    ]
    manager.startAdvertising(data)
  }
  
  private func createServices() -> [CBMutableService] {
    return [createDataService(), createNotifyService()]
  }
  
  private func createNotifyService() -> CBMutableService {
    let service = CBMutableService(type: .Service.notify, primary: true)
    
    do {
      // let data = "bud.notify.notify.charValue".data(using: .utf8)
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
      let data = "bud.data.read.charValue".data(using: .utf8)
      let char = CBMutableCharacteristic(type: .Char.read,
                                         properties: .read,
                                         value: data,
                                         permissions: .readable)
      
      let desc = "bud.data.read.descValue"
      let descriptor = CBMutableDescriptor(type: .Desc.desc,
                                           value: desc)
      char.descriptors = [descriptor] + (char.descriptors ?? [])
      
      service.characteristics = [char] + (service.characteristics ?? [])
    }
    
    do {
      // let data = "bud.data.readWrite".data(using: .utf8)
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
    print(#function, info(of: error))
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
    print("did add service", service)
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager,
                         central: CBCentral,
                         didSubscribeTo characteristic: CBCharacteristic) {
    
    guard let char = characteristic as? CBMutableCharacteristic else {
      return
    }
    
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      let date = Date()
      let data = try! JSONEncoder().encode(date)
      peripheral.updateValue(data,
                             for: char,
                             onSubscribedCentrals: [central])
    }
  }
}
