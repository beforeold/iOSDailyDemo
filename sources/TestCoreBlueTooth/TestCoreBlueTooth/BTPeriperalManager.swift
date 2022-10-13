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
                                         properties: [.notify, .write],
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
    print("didSubscribeTo: ", characteristic.readableDesc)
    
    guard let char = characteristic as? CBMutableCharacteristic else {
      return
    }
    
    return
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      let date = Date()
      let data = try! JSONEncoder().encode(date)
      peripheral.updateValue("hello luffy".data(using: .utf8)!,
                             for: char,
                             onSubscribedCentrals: [central])
    }
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
    print("didReceiveRead \(request.characteristic.readableDesc)")
    guard request.characteristic.properties.contains(.read) else {
      peripheral.respond(to: request, withResult: .readNotPermitted)
      return
    }
    
    let data = request.characteristic.value
    request.value = data
    peripheral.respond(to: request, withResult: .success)
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
    print("didReceiveWrite \(requests.map(\.characteristic.readableDesc))")
    for request in requests {
      guard request.characteristic.properties.contains(.write) else {
        peripheral.respond(to: request, withResult: .writeNotPermitted)
        continue
      }
      
      guard let char = request.characteristic as? CBMutableCharacteristic else {
        peripheral.respond(to: request, withResult: .writeNotPermitted)
        continue
      }
      // return;
      let data = request.value
      char.value = data
      peripheral.respond(to: request, withResult: .success)
      
      // response data
      if char.isNotify {
        var string = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        string += ".bud"
        print("did response: ", string)
        peripheral.updateValue(string.data(using: .utf8)!,
                               for: char,
                               onSubscribedCentrals: nil)
      }
    }
  }
}
