//
//  main.swift
//  TestJSONDictionaryKey
//
//  Created by BrookXy on 2022/4/2.
//

import Foundation

func foo() {
    let jsonString = """
    {
    {
        "key1": "value1"
    }: "value2"
    }
    """

    let data = jsonString.data(using: .utf8)

    if let data = data {

        do {
            let map = try JSONSerialization.jsonObject(with: data, options: [])
            print(map)
            let hashMap = map as? [AnyHashable: Any]
            print(hashMap as Any)
        } catch let error {
            print(error)
        }
    } else {
        print("no data")
    }
}

func bar() {
    do {
        let dic1 = ["id": 666]
        let d1 = try! JSONSerialization.data(withJSONObject: dic1, options: [])
        let str1 = String(data: d1, encoding: .utf8)!
        let obj = [str1: [4, 5, 6]]

        let data = try JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted])
        print(data.count)
        print(String(data: data, encoding: .utf8)!)
    } catch let error {
        print(error)
    }
}

foo()
bar()

