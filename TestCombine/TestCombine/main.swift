//
//  main.swift
//  TestCombine
//
//  Created by dinglan on 2021/5/7.
//

import Foundation
import Combine


func fa() {
    let publisher = PassthroughSubject<Int, Never>()
    print("开始订阅")
    _ = publisher.sink(
        receiveCompletion: { complete in
            print(complete)
        },
        receiveValue: { value in
            print(value)
        }
    )
    
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)
    
    publisher.send(3)
    publisher.send(completion: .finished)
}

func fb() {
    let publisher = CurrentValueSubject<Int, Never>(0)
    publisher.value = 1
    publisher.value = 2
    publisher.send(completion: .finished)
    print("开始订阅")
    _ = publisher.sink(
        receiveCompletion: { complete in
            
            print(complete)
        },
        receiveValue: { value in
            print(value)
        }
    )
}

func fc() {
    let publisher = CurrentValueSubject<Int, Never>(0)
    print("开始订阅")
    _ = publisher.sink(
        receiveCompletion: { complete in
            print(complete)
        },
        receiveValue: { value in
            print(value)
        }
    )
    publisher.value = 1
    publisher.value = 2
    publisher.send(3)
    publisher.send(completion: .finished)
    print("--- \(publisher.value) ---")
}

fa()
//fb()
//fc()
