//
//  Intent.swift
//  TestMVI
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation

class Intent {
    private let reducer = Reducer()
    private weak var view: Stateful?
    
    public func bind(to view: Stateful) {
        self.view = view
        
        var store = Store.shared
        store.observe {[weak self] state in
            self?.view?.updateState(state)
        }
    }
    
    public func onNext() {
        let newState = reducer.getNextState()
        present(newState: newState)
    }
    
    private func present(newState: State) {
        let store = Store.shared
        store.accept(newState)
        
//        let s = Store(state: newState)
//        s.accept(newState)
    }
}
