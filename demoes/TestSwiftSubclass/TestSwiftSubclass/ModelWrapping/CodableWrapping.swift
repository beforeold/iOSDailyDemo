//
//  CodableWrapping.swift
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

import Foundation

@objc(_lion_no_objc_direct_subclassing_CodableWrapper)
public class CodableWrapper: TBJSONModel {
    /// parsed data when init
    fileprivate var parsedData: Data
    
    /// the codable result, use implicit optional to determine whether has parsed
    ///
    /// @Note will return nil if callbed before self.model
    public var codableResult: Result<Any, Error>?
    
    public override init(jsonDictionary dict: [AnyHashable : Any]) throws {
        parsedData = try JSONSerialization.data(withJSONObject: dict, options: [])
        try super.init(jsonDictionary: dict)
    }
}

public protocol CodableWrapping: CodableWrapper {
    associatedtype CodableModel: Decodable
    var base: CodableModel? { get }
}

fileprivate func lion_decode<Model: Decodable>(_ type: Model.Type,
                                               from data: Data) throws -> Model
{
    try JSONDecoder().decode(type, from: data)
}

public extension CodableWrapping {
    var base: CodableModel? {
        if let result = codableResult {
            return try? result.get() as? CodableModel
        }
        
        // parse codable model
        do {
            let model = try lion_decode(CodableModel.self, from: parsedData)
            codableResult = .success(model)
        } catch {
            codableResult = .failure(error)
        }
        
        // clean data
        parsedData = Data()
        
        return try? codableResult?.get() as? CodableModel
    }
    
    var isEmptyWrapper: Bool {
        return base == nil
    }
}

// MARK: - example

struct Person: Codable {
    var name: String
}

@objc(LAPerson)
class LAPerson: CodableWrapper, CodableWrapping {
    typealias CodableModel = Person
}

struct Teacher: Codable {
    var name: String
}

@objc(LATeacher)
class LATeacher: CodableWrapper, CodableWrapping {
    typealias CodableModel = Teacher
}

