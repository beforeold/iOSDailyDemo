//
//  LionCodableBox.swift
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/11/2.
//

import Foundation


@objc(SwiftCodableBox)
public class SwiftCodableBox: TBJSONModel {
    private var jsonDictionary: [AnyHashable: Any]!
    private var model: Any!
    
    override init(jsonDictionary dict: [AnyHashable : Any]) {
        // cache json for unboxing later
        self.jsonDictionary = dict
        super.init(jsonDictionary: dict)
    }
    
    /// unbox the codable box
    ///
    /// @Note subscript is supported
    public func unbox<Model: Decodable>(as type: Model.Type) -> Model? {
        if let model = model as? Model {
            return model
        }
        
        guard let json = jsonDictionary else { return nil }
        
        let model: Model? = decode(json: json)
        // clear dict after unboxing
        self.jsonDictionary = nil
        self.model = model
        
        return model
    }
   
    
    /// unbox throught subscript
    public subscript<Model: Decodable>(type: Model.Type) -> Model? {
        unbox(as: type)
    }

    private func decode<Model>(json: [AnyHashable: Any]) -> Model? {
        // json -> data
        // data -> codable model
        nil
    }
}

public
extension Optional where Wrapped: SwiftCodableBox {
    func unbox<Model: Decodable>(as type: Model.Type) -> Model? {
        self?.unbox(as: type)
    }
    
    subscript<Model: Decodable>(type: Model.Type) -> Model? {
        self?.unbox(as: type)
    }
}
