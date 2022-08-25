//
//  main.swift
//  TestURLOptional
//
//  Created by 席萍萍Brook.dinglan on 2021/9/25.
//

import Foundation

print("Hello, World!")

func foo() {
    let url = URL(string: "https://www.apple.com")!
    let str = "\(String(describing: url.host))-\(url.path)"
    print(str)
}

foo()
