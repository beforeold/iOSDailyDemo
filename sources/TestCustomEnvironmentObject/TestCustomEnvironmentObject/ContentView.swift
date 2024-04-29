//
//  ContentView.swift
//  TestCustomEnvironmentObject
//
//  Created by beforeold on 2023/11/19.
//

import SwiftUI

protocol CustomEnvironmentObjectProtocol: ObservableObject {}

struct GenericEnvironmentKey: EnvironmentKey {
  static var defaultValue: [String: Any] = [:]
}

extension EnvironmentValues {
  var customObject: [String: Any] {
    get { self[GenericEnvironmentKey.self] }
    set { self[GenericEnvironmentKey.self] = newValue }
  }
}

@propertyWrapper
struct CustomEnvironment<Value: CustomEnvironmentObjectProtocol>: DynamicProperty {
  @Environment(\.customObject) private var envObject: [String: Any]
  
  var wrappedValue: Value {
      let typeAsKey = "\(type(of: Value.self))"
      return envObject[typeAsKey] as! Value
  }
}

extension View {
    func customEnvironmentObject<T: ObservableObject>(_ object: T) -> some View {
        let anyObject = AnyObservableObject(object)
        let objectId = ObjectIdentifier(T.self)
        return self.environment(\.customEnvironmentObjects, { currentObjects in
            var newObjects = currentObjects
            newObjects[objectId] = anyObject
            return newObjects
        }())
    }
}


extension View {
  func customEnvironmentObject<Value: CustomEnvironmentObjectProtocol>(_ object: Value) -> some View {
    let typeAsKey = "\(type(of: Value.self))"
    var envObject = Environment(\.customObject).wrappedValue
    envObject[typeAsKey] = object
    return environment(\.customObject, envObject)
  }
}

class SampleObjectA: CustomEnvironmentObjectProtocol {
  @Published var dataA: String = "Data A"
}

class SampleObjectB: CustomEnvironmentObjectProtocol {
  @Published var dataB: String = "Data B"
}

struct ContentView: View {
  @CustomEnvironment var objectA: SampleObjectA
  @CustomEnvironment var objectB: SampleObjectB
  
  var body: some View {
    VStack {
      Text("Object A Data: \(objectA.dataA)")
      Text("Object B Data: \(objectB.dataB)")
    }
    .onAppear {
      objectA.dataA = "Updated Data A"
      objectB.dataB = "Updated Data B"
    }
  }
}

struct ParentView: View {
  var body: some View {
    ContentView()
      .customEnvironmentObject(SampleObjectA())
      .customEnvironmentObject(SampleObjectB())
  }
}

#Preview {
  ContentView()
    .customEnvironmentObject(SampleObjectA())
    .customEnvironmentObject(SampleObjectB())
}
