//
//  CodableBoxable.swift
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/11/2.
//

import Foundation


protocol CodableBoxable {
    var jsonDictionary: [AnyHashable: Any]! { get set }
    var model: Any! { get set }
    
    
    /// unbox the codable box
    ///
    /// @Note subscript is supported
    mutating func unbox<Model: Decodable>(as type: Model.Type) -> Model?

    func decode<Model>(json: [AnyHashable: Any]) -> Model?
}

extension CodableBoxable {
    
    /// unbox the codable box
    ///
    /// @Note subscript is supported
    public mutating func unbox<Model: Decodable>(as type: Model.Type) -> Model? {
        if let model = model as? Model {
            return model
        }
        
        guard let json = jsonDictionary else { return nil }
        
        let model: Model? = decode(json: json)
        // clear dict after unboxing
        self.jsonDictionary = nil
        self.model = model as Any
        
        return model
    }

    private func decode<Model>(json: [AnyHashable: Any]) -> Model? {
        // json -> data
        // data -> codable model
        nil
    }
}
