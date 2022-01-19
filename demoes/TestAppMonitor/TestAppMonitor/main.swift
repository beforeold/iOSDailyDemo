//
//  main.swift
//  TestAppMonitor
//
//  Created by BrookXy on 2022/1/18.
//

import Foundation


// + (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint dimensionValueSet:(nullable AppMonitorDimensionValueSet *)dimensionValues measureValueSet:(nullable AppMonitorMeasureValueSet *)measureValues;



//
//protocol {
//    func set(_ dimention: Any, for dimentKey: String)
//    func set(_ measure: Any, for measureKey: String)
//}


struct Monitor {
    let module: String
    let point: String
    
    init(module: String, point: String, disments: String..., measure: String...) {
        
        self.module = module
        self.point = point
        // register
    }
    
    class Object {
        private var dDict = [String: String]()
        private var mDict = [String: Double]()
        
        func set(_ string: String, for dimen: String) {
            
        }
        
        func set(_ string: String, forMsure: String) {
            
        }
    }
    
    func commit( _ builder: (Object) -> Void) {
        let obj = Object()
        builder(obj)
        // use two dicts
        
    }
}


fileprivate
func foo() {
    let monitor = Monitor(module: "module",
                          point: "point",
                          measure: "m1", "m2")
    monitor.commit { obj in
        obj.set("", for: "")
        obj.set("", for: "")
        obj.set("", for: "")
    }
}

//protocol Dprotocol {
//
//}
//
//struct MyD: Dprotocol, Codable {
//
//}
//
//(dimentsion, string)
//(meausre, double)
//
//
//func commit<D>(d: MyD) {
//
//}

protocol Monitorable: Encodable {
    associatedtype Value: Encodable
    associatedtype Keys: CodingKey, CaseIterable
}

struct Dimension: Monitorable {
    typealias Value = String
    typealias Keys = CodingKeys
    
    enum CodingKeys: CodingKey, CaseIterable {
        case key1, key2
    }
    
    var key1: String
    var key2: String
}

struct Measure: Monitorable {
    typealias Value = Double
    typealias Keys = CodingKeys
    
    enum CodingKeys: CodingKey, CaseIterable {
        case key1, key2
    }
    
    var key1: Double
    var key2: Double
}

struct EmptyMeasure: Monitorable {
    typealias Value = Double
    
    enum CodingKeys: CodingKey, CaseIterable { }
    
    enum Keys2: CodingKey {}

    typealias Keys = CodingKeys
}

struct Retry {
    struct Monitor<D: Monitorable, M: Monitorable> where D.Value == String, M.Value == Double
    {
        init() {
            let stringArray = D.Keys.allCases.map { $0.stringValue }
            print(stringArray)
        }
        
        func commit(d: D, m: M) {
            let data = try? JSONEncoder().encode(d)
            let dict = data.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) } as? [String: String]
            // enumerate dict
            print(dict as Any)
        }

    }
    
    func foo() {
        let ins = Monitor<Dimension, Measure>()
        ins.commit(d: Dimension(key1: "", key2: ""),
                   m: Measure(key1: 1, key2: 2))
    }
}
