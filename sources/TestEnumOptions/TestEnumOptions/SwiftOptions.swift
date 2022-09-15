//
//  SwiftOptions.swift
//  TestEnumOptions
//
//  Created by 席萍萍Brook.dinglan on 2021/12/15.
//

import Foundation

struct SwiftEnum: OptionSet {
    let rawValue: Int

    static let start = SwiftEnum([])
    static let didLoad = SwiftEnum(rawValue: 1 << 0)
    static let willAppear = SwiftEnum(rawValue: 1 << 1)
    static let didAppear = SwiftEnum(rawValue: 1 << 2)

    static let all: SwiftEnum = [.start, .didLoad, .willAppear, didAppear]
}

class SwiftTest: NSObject {
    @objc static func test() {
        let set: SwiftEnum = [.start, .didLoad]
        print(set.contains(.start))
        print(set.contains(.didLoad))
        
        print(SwiftEnum.all.contains([.start]))
        print(SwiftEnum.all.contains([.didLoad]))
        
        print(SwiftEnum.start.contains(.start))
    }
}
