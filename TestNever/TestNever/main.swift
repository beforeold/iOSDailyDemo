//
//  main.swift
//  TestNever
//
//  Created by BrookXy on 2022/1/10.
//

import Foundation
import AppKit
import Combine

func get5() -> Int {
    undefined()
}

var pass: Never {
    fatalError()
}

func undefined<T>(_ msg: String = "undefined implementation") -> T {
    fatalError(msg)
}

let string: String?

class MyVC: NSViewController {
    init(name: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let empty = Empty(completeImmediately: false, outputType: String.self, failureType: Never.self)
_ = empty.sink(receiveCompletion: undefined(), receiveValue: undefined())

let sub = PassthroughSubject<String, NSError>()


var ret: Result<String, Never> = .success("ok")
func foo() {
    switch ret {
//    case .failure:
//        print("")
//
    case .success:
        print("")
    }
}


let timer = Timer.init(timeInterval: undefined(),
                       target: undefined(),
                       selector: undefined(),
                       userInfo: undefined(),
                       repeats: undefined())


let timer2 = Timer(timeInterval: undefined(),
                   repeats: undefined(),
                   block: undefined())

extension MyVC: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        undefined()
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        undefined()
    }
}



extension Publisher {
    public func sink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void),
                     receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable
}

extension Publisher where Self.Failure == Never {
    public func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable
}
