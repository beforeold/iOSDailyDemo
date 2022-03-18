//
//  ViewController.swift
//  TestJSONDictionaryToArray
//
//  Created by BrookXy on 2022/3/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? sortAndExport()
    }

    func sortAndExport() throws {
        // fetch file
        // to json object
        // to array
        // to file
        
        
        guard let file = Bundle.main.path(forResource: "dependency", ofType: "json") else {
            print("no file")
            return
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: file))
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dict = object as? [String: String] else {
            print("not dict")
            return
        }
      
        let array = dict.map { (key: String, value: String) -> Pod in
            return Pod(name: key, version: value)
        }.sorted()
        
        let arrayData = try JSONEncoder().encode(array)
        let targetPath = NSTemporaryDirectory() + UUID().uuidString + ".json"
        let targetURL = URL(fileURLWithPath: targetPath)
        try arrayData.write(to: targetURL)
        print("result ==> \(targetURL)")
    }
}


struct Pod: Codable, Comparable {
    static func < (lhs: Pod, rhs: Pod) -> Bool {
        return lhs.name < rhs.name
    }
    
    let name: String
    let version: String
}
