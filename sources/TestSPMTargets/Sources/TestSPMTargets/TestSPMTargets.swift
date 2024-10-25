// The Swift Programming Language
// https://docs.swift.org/swift-book
import TestSPMTargetsCore

public struct Full {
  public static func foo() {
    print(#function)

    Core.foo()
  }
}
