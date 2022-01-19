//
//  main.swift
//  TestSwiftErrorOrCrash
//
//  Created by BrookXy on 2022/1/19.
//

import Foundation

func fail() throws {
    throw NSError()
}

func crash() {
    let array = [1, 2]
    print(array[666])
}

 try? fail()

//crash()

print("end")
