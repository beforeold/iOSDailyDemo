//
//  SwiftFile.swift
//  TestSwift_at_Objc
//
//  Created by BrookXy on 2022/1/9.
//

import Foundation


class Animal: NSObject {
    
}

class Dog: Animal {
    func bark() {}
    
    @objc var name: String?
}

class Student: OCPerson {
    
}

public class JustClass: NSObject {
    public func okok() { }
}

@objc
public class ObjcClass: NSObject {
    public func okok() { }
}


@objc(OCRenamedClass)
public class RenameClass: NSObject {
    public func okok() { }
}

@objc(OCMemerersRenamed)
@objcMembers
public class MemberClass: NSObject {
    public func okok() { }
}

