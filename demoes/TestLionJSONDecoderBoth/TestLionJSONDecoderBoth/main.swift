//
//  main.swift
//  TestLionJSONDecoderBoth
//
//  Created by 席萍萍Brook.dinglan on 2021/12/20.
//

import Foundation

protocol LionDecodingConfiguring {}
let enableLionFlag = true

protocol Boldable: Decodable {
    associatedtype B: Decodable, LionDecodingConfiguring
    func bolded() -> B
}


@propertyWrapper
struct DowngradeWith<T: Boldable>: Decodable {
    var wrappedValue: T.B
    init(from decoder: Decoder) throws {
        if enableLionFlag {
            let bold = try decoder.singleValueContainer().decode(T.B.self)
            self.wrappedValue = bold
        } else {
            let empty = try decoder.singleValueContainer().decode(T.self)
            self.wrappedValue = empty.bolded()
        }
    }
}

@propertyWrapper
struct OptionalDowngradeWith<T: Boldable>: Decodable {
    var wrappedValue: T.B?
    init(from decoder: Decoder) throws {
        if enableLionFlag {
            let bold = try? decoder.singleValueContainer().decode(T.B.self)
            self.wrappedValue = bold
        } else {
            let empty = try? decoder.singleValueContainer().decode(T.self)
            self.wrappedValue = empty?.bolded()
        }
    }
}


struct Empty {
    var name: String?
}

extension Empty: Boldable {
    func bolded() -> Bold {
        return Bold(name: self.name ?? "")
    }
}

struct Bold: Decodable, LionDecodingConfiguring {
    var name: String
}

struct Root: Decodable {
    @DowngradeWith<Empty>
    var object: Bold
    
    @OptionalDowngradeWith<Empty>
    var object2: Bold?
}


let root: Root? = nil
print(root?.object.name as Any)
