//
//  main.swift
//  TestJSONSerializationOption
//
//  Created by 席萍萍Brook.dinglan on 2021/12/3.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    public var toJsonString: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.fragmentsAllowed]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .utf8)
    }
}

let obj = ["name": "brook"]

print(obj.toJsonString!)

/*
// prettyPrinted
{
  "name" : "brook"
}
*/

// empty option
// {"name":"brook"}
