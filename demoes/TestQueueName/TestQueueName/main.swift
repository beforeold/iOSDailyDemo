//
//  main.swift
//  TestQueueName
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation

print("Hello, World!")

DispatchQueue.global().async {
    print("name: \(OperationQueue.current?.name as Any)")
}

sleep(5)
