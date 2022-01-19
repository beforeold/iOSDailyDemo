//
//  main.swift
//  TestLookupJSON
//
//  Created by BrookXy on 2022/1/9.
//

import Foundation

let string: String? = nil

let json = [
    "int": 5,
    "array": [
        0,
        1,
        2,
    ],
    "dict": [
        "key1": "key1",
        "key2": "key2",
    ],
    "nilValue": string as Any,
] as [String : Any]


let nilDict: [String: Any]? = nil

let empty = [String: Any]()

/*
func test(_ value: Any) {
    func log(_ v: Any?) {
        if let v = v {
            print(v)
        } else {
            print("nil")
        }
    }
    
    log(JSON(value).dict.key1.get(as: String.self))
    log(JSON(value).int.get(as: Int.self))
    log(JSON(value).array[2].get(as: Int.self))
    log(JSON(value).nilValue.get(as: String.self))
    
    log("")
}

//test(json)
//test(nilDict as Any)
//test(empty)

print(JSON(nil).stringValue)


extension NSObject {
    subscript(dynamicMember dynamicMember: String) -> Any? {
        return nil
    }
}

func obj() {
    let ins = NSObject()
    print(ins[dynamicMember: "okok"])
    // not supported
    // ins.okok
}
obj()
*/

