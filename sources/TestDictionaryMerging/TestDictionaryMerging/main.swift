//
//  main.swift
//  TestDictionaryMerging
//
//  Created by xipingping on 6/13/24.
//

import Foundation

//protocol AnyProperty {
//
//}

typealias AnyProperty = Any

// extension Int conforms to AnyProperty
extension Int: AnyProperty {
}

var commonProperties: [String: AnyProperty] = ["key1": 1]
var properties: [String: AnyProperty] = [
  "key1": 666,
  "key2": 2
]

let propertiesAfter = commonProperties.merging(properties) { _, _ in
}

let nsDictionay = NSDictionary(dictionary: propertiesAfter)

print("merging ret", propertiesAfter)
print("as NSDictionary", nsDictionay)

// __SwiftValue
let key1 = nsDictionay["key1"] as! NSObject
print("ns key1:", key1)
print("ns key1 type:", type(of: key1))
