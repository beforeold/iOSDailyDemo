//
//  ViewController.swift
//  TestSwiftOCArrayBriding
//
//  Created by BrookXy on 2022/2/7.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // testNilNumber()
        
        // testStringArrayCast()
        
        testCastingMutableArray()
        
        // testCastingImmutableArray()
        
        // testInline()
        
        // testNilString()
        
        // parseResultArray()
        
        // contextParseResultArray()
        
        // testGetObjectType(arg: MLCPageContext.testNilNumber())
        
        print("=== test end ====")
    }
    
    
    @inlinable
    func testInline() {
        print("inlined")
        actual()
    }
    
    func actual() {
        print("inlined")
    }
    
    func testStringArrayCast() {
        let context = MLCPageContext()
        let result = context.parseResult.mutableArray as? [String]
        print(result as Any)
    }
    
    func testCastingMutableArray() {
        let result = MLCParseResult()
        let array = result.mutableArray as? [MLCComponent]
        print(array as Any)
        
        // always crash
        print(result.mutableArray)
    }
    
    func testCastingImmutableArray() {
        let result = MLCParseResult()
        let array = result.immutableArray
        print(array)
        print(result.immutableArray)
    }
    
    func testNilString() {
        let value = MLCPageContext.testNilString()
        print(value)
        print(value.count, "---")
        
        let context = MLCPageContext()
        
        print(context.name.count)
        print(context.name)
        
        // always crash
        print(context.parseResult)
    }
    
    func testNilNumber() {
        let value = MLCPageContext.testNilNumber()
        print(value.intValue)
        print(value.description)
        
        // always crash
        print(value)
        print(type(of: value), "---")
    }
    
    
    func parseResultArray() {
        let parseResult = MLCParseResult()
        //        let array = parseResult.array as? [MLCComponent] ?? []
        //        print(array)
        
        // always crash
        print(parseResult.mutableArray)
    }
    
    func contextParseResultArray() {
        let context = MLCPageContext()
        let array = context.parseResult.mutableArray as? [MLCComponent] ?? [MLCComponent]()
        print(array)
        
        // always crash
        print(context.parseResult.mutableArray)
    }
    
    func testGetObjectType(arg: NSObject) {
        // let type = type(of: arg)
        // print(type)
        
        if let string = arg as? String {
            print(string)
        } else {
            print("not string")
        }
        
        let desc = arg.description
        print("arg.description", desc)
        
        NSLog("nslog arg %@", arg)
        
        // always crash
        print(arg)
    }
}

