import SwiftUI

@main
struct TestMultiLibraryPackageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .onAppear {
              foo()
            }
        }
    }
}

import BizTemplateA

func foo() {
  FileA.foo()
}
