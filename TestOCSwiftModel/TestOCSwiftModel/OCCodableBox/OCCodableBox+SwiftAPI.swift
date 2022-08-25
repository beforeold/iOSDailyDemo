//
//  OCCodableBox+SwiftAPI.swift
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/11/2.
//

import Foundation

public extension OCCodableBox {
    /// token for record handled once
    private struct Once {
        var model: Any
    }
    
    /// unbox the codable box
    ///
    /// @Note subscript is supported
    func unbox<Model: Decodable>(as type: Model.Type) -> Model? {
        if let once = self.modelContainer.firstObject as? Once {
            return once.model as? Model
        }
        
        // decode
        let model = try? decode(Model.self, from: jsonDictionary)
        
        // clear dict after unboxing
        jsonDictionary = [:]
        
        // save once
        modelContainer[0] = Once(model: model as Any)
        
        return model
    }
   
//    /// unbox throught subscript
//    subscript<Model: Decodable>(type: Model.Type) -> Model? {
//        unbox(as: type)
//    }

    private func decode<Model: Decodable>(_ type: Model.Type,
                                          from json: [AnyHashable: Any]) throws -> Model
    {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return try JSONDecoder().decode(type, from: data)
    }
}


public
extension Optional where Wrapped: OCCodableBox {
    // func unbox<Model: Decodable>(as type: Model.Type) -> Model? {
//         self?.unbox(as: type)
   //  }
    
//
//    subscript<Model: Decodable>(type: Model.Type) -> Model? {
//        self?.unbox(as: type)
//    }
}
