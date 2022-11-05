//
//  ViewModelProtocol.swift
//  TestKickstarterMVVM
//
//  Created by beforeold on 2022/11/5.
//

import Foundation
// inspired by Kickstarter ios-oss
// https://engineering.mercari.com/en/blog/entry/2019-06-12-120000/

public protocol ViewModelProtocol {
    associatedtype Inputs
    associatedtype Outputs
    
    var inputs: Inputs { get }
    var outputs: Outputs { get }
}

