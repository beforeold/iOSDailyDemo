//
//  DemoDocumentppApp.swift
//  DemoDocumentpp
//
//  Created by beforeold on 2025/10/28.
//

import SwiftUI

@main
struct DemoDocumentppApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: DemoDocumentppDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
