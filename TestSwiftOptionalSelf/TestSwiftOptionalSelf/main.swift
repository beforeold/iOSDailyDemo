//
//  main.swift
//  TestSwiftOptionalSelf
//
//  Created by BrookXy on 2022/1/20.
//

import Foundation

// sharedInstance().tabBarController?.self.debugDescription

var optionalString: String!

print(optionalString?.self.description as Any)

let value = optionalString?.self.description
print(value as Any)

print(optionalString.self.description)

let selfValue = optionalString.self
print(selfValue.description)

// self is a property
// https://docs.swift.org/swift-book/LanguageGuide/Methods.html
