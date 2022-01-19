//
//  Person.swift
//  TestSwiftIntOptional
//
//  Created by 席萍萍Brook.dinglan on 2022/1/5.
//

import Foundation

@objcMembers
@objc(Person)
class Person: TBJSONModel {
    var age: Int = 0
    var name: String?
    var flag: Bool = false
}

struct SwiftPerson: Codable {
    var age: Int?
    var name: String?
    var flag: Bool?
}
