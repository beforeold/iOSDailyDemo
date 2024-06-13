//
//  main.swift
//  TestDictionaryMerging
//
//  Created by xipingping on 6/13/24.
//

import Foundation

protocol AnyProperty {

}

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

print("ret", propertiesAfter)
