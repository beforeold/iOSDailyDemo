//
//  main.swift
//  TestOCSwiftModel
//
//  Created by 席萍萍Brook.dinglan on 2021/10/19.
//

import Foundation

/*
extension ModelWrapper {
    @objc class func model(withJSONDictionary: [AnyHashable: Any]) {
        guard let type = Model as? Codable.Type {
            
        }
    }
}
*/

struct ActualModel: Codable {
    var name = "brook"
}


let ocRootModel = OCRootModel(jsonDictionary: [:])
let model = ocRootModel.person?.unbox(as: ActualModel.self)

let kingBox = ocRootModel.king
_ = kingBox?.unbox(as: ActualModel.self)

_ = ocRootModel.king?.unbox(as: ActualModel.self)?.name

_ = ocRootModel.person?.unbox(as: ActualModel.self)
_ = ocRootModel.person.unbox(as: ActualModel.self)
_ = ocRootModel.person[ActualModel.self]?.name

class SwiftRootModel {
    var person: SwiftCodableBox?
}

let swiftRootModel = SwiftRootModel()
_ = swiftRootModel.person?.unbox(as: ActualModel.self)?.name
_ = swiftRootModel.person[ActualModel.self]?.name

extension Decodable {
    static func create(from box: SwiftCodableBox?) -> Self? {
        box?.unbox(as: Self.self)
    }
}
_ = ActualModel.create(from: ocRootModel.person!)?.name


