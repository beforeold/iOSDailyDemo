//
//  RxObservableType.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import Foundation
import RxSwift


extension ObservableType {
  fileprivate func demo(_ name: String) {
    print("\n======== \(name) ======= ")
    
    _ = subscribe { event in
      print(event)
    }
  }
}

struct RxObservableType {
  
  static func test() {
    Observable<Int>.empty().demo("empty")
    
    Observable<Int>.just(5).demo("just")
    
    Observable.of(1, 2, 3).demo("of")
    
    
    Observable<Any>.error(MyError.one).demo("error")
    
    myJust(4).demo("myjust ok")
    myJust(5).demo("myjust error")
    
    Observable.generate(initialState: 0,
                        condition: { $0 < 10},
                        iterate: { $0 + 1 })
    .demo("generate")
    
    let pub = Observable.generate(initialState: 0,
                        condition: { $0 < 10},
                        iterate: { $0 + 1 })
    pub.demo("pub 1")
    pub.demo("pub 2")
    
    // defered 的主要是在订阅时才去构造内部的 publisher
    let defered = Observable.deferred {
      print("create pub")
      return pub
    }
    defered.demo("defered 1")
    defered.demo("defered 2")
  }
}


fileprivate enum MyError: Error { case one }

fileprivate func myJust(_ value: Int) -> Observable<Int> {
  return Observable.create { sub -> Disposable in
    if value % 2 == 0 {
      sub.onNext(value)
      sub.onCompleted()
    } else {
      sub.onError(MyError.one)
    }
    
    return Disposables.create()
  }
}
