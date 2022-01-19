//
//  main.swift
//  TestSwiftTryCatchPerformance
//
//  Created by 席萍萍Brook.dinglan on 2021/11/25.
//

import Foundation

enum A: Error {
    case a
}

func fail() throws -> Int {
    return 5
    throw A.a
}

func myprint(_ an: Any) {
    
}

let before = CFAbsoluteTimeGetCurrent()
for _ in 0...100000 {
    do {
        _ = try fail()
    } catch {
        
    }
}
let after = CFAbsoluteTimeGetCurrent()
print(after - before)

