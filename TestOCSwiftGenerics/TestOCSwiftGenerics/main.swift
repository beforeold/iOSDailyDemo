//
//  main.swift
//  TestOCSwiftGenerics
//
//  Created by dinglan on 2021/5/20.
//

import Foundation
import CoreData

print("Hello, World!")


func testModel() {
    let subModel = SubModel()
    let jsonModel = subModel.jsonModel
    print(jsonModel)
}

class SwiftSubModel: BaseModel<BaseJsonModel> {
    
}


func testDefaultViewModel() {
    let submodel = SubModel<SubJsonModel>()
    _ = submodel.jsonModel
    
    class SwiftCellViewModel: BaseCellViewModel<SwiftSubModel> {

    }
    
    let vm = SwiftCellViewModel()
    let model = vm.model
    
}

class SomeResult: NSObject, NSFetchRequestResult {
    
}


class BaseJsonModel_SubModel: BaseModel<BaseJsonModel> {
    
}


//let obj = ins.object(at: .init())
