//
//  MyViewModel.swift
//  TestKickstarterMVVM
//
//  Created by beforeold on 2022/11/5.
//

import Foundation
import Combine

protocol MyInputsProtocol {
    func onTap()
}


protocol MyOutputsProtocol {
    var textValue: any Publisher<String, Never> { get }
}

class MyViewModel: ViewModelProtocol {
    var inputs: MyInputsProtocol {
        self
    }
    
    var outputs: MyInputsProtocol {
        self
    }
    
    private var textValueSubject = PassthroughSubject<String, Never>()
    
    init() {
        
    }
}


extension MyViewModel: MyInputsProtocol {
    func onTap() {
        textValueSubject.send("on tap")
    }
}


extension MyViewModel: MyOutputsProtocol {
    var textValue: any Publisher<String, Never> {
        return self.textValueSubject
    }
}
