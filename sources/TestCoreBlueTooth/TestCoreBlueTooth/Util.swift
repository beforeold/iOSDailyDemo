//
//  Util.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/12.
//

import Foundation
import CoreBluetooth

internal func info(of error: Error?) -> String {
  let info = (error as? NSError)?.userInfo ?? [:]
  let obj = info as NSDictionary
  return "error: " + obj.description
}

extension CBUUID {
  enum Service {
    static let data = CBUUID(string: "AAAA")
    static let notify = CBUUID(string: "BBBB")
  }
  
  enum Char {
    static let read = CBUUID(string: "CCCC")
    static let readWrite = CBUUID(string: "DDDD")
    static let notify = CBUUID(string: "EEEE")
  }
  
  enum Desc {
    static let desc = CBUUID(string: CBUUIDCharacteristicUserDescriptionString)
  }
}

extension CBCharacteristic {
  var isNotify: Bool {
    return uuid.uuidString == CBUUID.Char.notify.uuidString
  }
  
  var isReadWrite: Bool {
    return uuid.uuidString == CBUUID.Char.readWrite.uuidString
  }
}

extension CBAttribute {
  var readableDesc: String {
    return "<\(_readableDesc)>"
  }
  
  private var  _readableDesc: String {
    switch uuid.uuidString {
    case CBUUID.Service.data.uuidString:
      return "bud.service.data"
      
    case CBUUID.Service.notify.uuidString:
      return "bud.service.notify"
      
    case CBUUID.Char.read.uuidString:
      return "bud.char.read"
      
    case CBUUID.Char.readWrite.uuidString:
      return "bud.char.readWrite"
      
    case CBUUID.Char.notify.uuidString:
      return "bud.char.notify"
      
    case CBUUID.Desc.desc.uuidString:
      return "bud.desc.desc"
      
    default:
      return uuid.uuidString
    }
  }
}
