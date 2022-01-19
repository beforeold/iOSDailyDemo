//
//  Student.swift
//  TestOCSwiftGenericSubclassing
//
//  Created by 席萍萍Brook.dinglan on 2021/12/16.
//

import Foundation

class SwiftBook {
    
}

@objc(OCBook)
class OCBook: NSObject {
    
}

@objc(Student)
class Student: Person<OCBook> {
    override func getName() -> String {
        return "name of student"
    }
}

@objc(Teacher)
class Teacher: Person<SwiftBook> {
    var book: SwiftBook?
    
    override func getName() -> String {
        return "name of teacher, book: \(book as Any)"
    }
    
    override init() {
        
    }
    
    init(swiftBooK: SwiftBook) {
        self.book = swiftBooK
    }
}

// YNMVVMBaseCollectionViewCell<LAPDPSectionBaseViewModel<LAPDPMainPageCellBaseModel<LAPDPBaseJSONModel>>>
