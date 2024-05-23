//
//  main.swift
//  TestJSONFormat
//
//  Created by Brook_Mobius on 11/29/23.
//

import Foundation

struct EventHelper {
  /// 整形数组 json string
  /// {"model_id":["1","2","3"]}
  static func buildModelIdList(_ modelIdList: [Int]?) -> String {
    let idList: [Int]
    if let modelIdList {
      idList = modelIdList
    } else {
      idList = [-1]
    }

    let value = [
      "model_id": idList.map { "\($0)" }
    ]

    var encoder = JSONEncoder()
    encoder.outputFormatting = .withoutEscapingSlashes
    let data = try? encoder.encode(value)
    let string = data.flatMap {
      String(data: $0, encoding: .utf8)
    }

    // format: [1,2,3] 或者 []
    return string ?? "{}"
  }
}

let string = EventHelper.buildModelIdList([1, 2])
print(string)
