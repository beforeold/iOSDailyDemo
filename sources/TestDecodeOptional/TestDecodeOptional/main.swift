//
//  main.swift
//  TestDecodeOptional
//
//  Created by xipingping on 5/20/24.
//

import Foundation

let json = #"""
{
"object": {
   "valueA": null
  }
}
"""#

//
//let json = #"""
//{
//"object": {
//  }
//}
//"""#

struct Root: Codable {
    struct Object: Codable {
        var valueA: Bool?

        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Root.Object.CodingKeys> = try decoder.container(keyedBy: Root.Object.CodingKeys.self)
            self.valueA = try container.decode(Bool?.self, forKey: Root.Object.CodingKeys.valueA)
        }
    }

    var object: Object
}

let data = json.data(using: .utf8)!
let root = try? JSONDecoder().decode(Root.self, from: data)
print(root.map { "\($0)"} ?? "null")

