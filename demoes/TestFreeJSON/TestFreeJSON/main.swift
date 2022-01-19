//
//  main.swift
//  TestFreeJSON
//
//  Created by BrookXy on 2022/1/13.
//

import Foundation

func test() {
    let json1 = FreeJSON(jsonString: orangeJsonString)[1].configs.first.filter.data.theme.layoutType
    print(json1.string == "lp_V5_1")
    
    let decoder = FreeJSONStringDecoder { $0.get(as: [[String: Any]].self) }
    let dict = try? decoder.decode(string: orangeJsonString)
    let json2 = FreeJSON(dict)[1].configs.first.filter.data.theme.layoutType
    print(json2.string == "lp_V5_1")
}

test()
