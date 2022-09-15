//
//  ViewController.swift
//  TestFunctionBuilder2
//
//  Created by dinglan on 2021/3/12.
//

import UIKit


@_functionBuilder
struct ArrayBuilder {
    static func buildBlock<T>(_ items: T...) -> [T] {
        items
    }
}

extension Array {
    init(@ArrayBuilder _ builder: () -> Self) {
        self = builder()
    }
}

func build<T>(@ArrayBuilder _ builder: () -> [T]) -> [T] {
    builder()
}
//
//@ArrayBuilder
//func foo() {
//
//}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let array = Array {
            1
            2
            3
        }
        
        let array2 = build {
            4
            5
            6
        }
        
        print(array)
        print(array2)
    }


}

