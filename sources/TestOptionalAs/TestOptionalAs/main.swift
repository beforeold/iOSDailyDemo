//
//  main.swift
//  TestOptionalAs
//
//  Created by dinglan on 2021/5/14.
//

import Foundation

var opString: Any? = "1"

if let ret = opString as? String {
    print("success \(ret)")
}
else {
    print("fail")
}
