//
//  PublicFile.swift
//  MYFramework
//
//  Created by 席萍萍Brook.dinglan on 2021/11/6.
//

import Foundation
import UIKit
import SwiftyRSA

// import SnapKit

public class PublicFile {
    public init() { }
    
    public func foo() {
        print("foo begin")
        rsa()
        print("foo done")
    }
    
//    func snap() {
//        let superView = UIView()
//        let subview = UIView()
//        superView.addSubview(subview)
//        subview.snp.makeConstraints { (make) in
//            make.leading.trailing.equalTo(0)
//            make.centerY.equalTo(0)
//        }
//    }
    
    func rsa() {
        let person = NSObject().swiftyRSA_name
        let name = person.name
        print(name as Any)
        
        _ = SwiftyRSAError.chunkDecryptFailed(index: 5)
        _ = try? PrivateKey(data: Data())
    }
}
