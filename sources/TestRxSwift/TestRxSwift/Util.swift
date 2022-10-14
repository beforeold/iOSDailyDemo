//
//  Util.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import Foundation
import RxSwift

extension ObservableType {
  public func sink(onNext: @escaping ((Element) -> Void)) -> Disposable {
    return subscribe(onNext: onNext)
  }
}
