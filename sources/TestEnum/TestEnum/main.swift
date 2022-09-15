//
//  main.swift
//  TestEnum
//
//  Created by BrookXy on 2022/1/8.
//

import Foundation

enum OrderState: Int {
    case new = 1
    case payed = 2
    case done = 3
}

enum OrderStateValue: Codable {
    case value(Int)
}

struct OrderStateStruct: RawRepresentable, Codable {
    let rawValue: Int
    
    static let new = OrderStateStruct(rawValue: 1)
    static let payed = OrderStateStruct(rawValue: 2)
    static let done = OrderStateStruct(rawValue: 3)
}


let _______ = OrderState(rawValue: 1)!

extension OrderState: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let int = try container.decode(Int.self)
        self = OrderState(rawValue: int) ?? _______
    }
}

struct Order: Codable {
    let id: Int
    let state: OrderState
}

let data = """
{"id":666, "state":3}
""".data(using: .utf8)!
let order = try! JSONDecoder().decode(Order.self, from: data)
print(order)

