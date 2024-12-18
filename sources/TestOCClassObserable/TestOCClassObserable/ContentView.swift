import SwiftUI

@Observable
@propertyWrapper
@dynamicMemberLookup
public final class ObservableModel<Base> {

  public var value: Base

  public var wrappedValue: ObservableModel<Base> {
    self
  }

//  public init(_ type: Base.Type) where Base: NSObject {
//    self.value = type.init()
//  }

  public init(wrappedValue initialValue: ObservableModel<Base>) {
    self.value = initialValue.value
  }

  public init(_ value: Base) {
    self.value = value
  }

  public subscript<V>(dynamicMember keyPath: WritableKeyPath<Base, V>) -> V {
    get {
      value[keyPath: keyPath]
    }
    set {
      value[keyPath: keyPath] = newValue
      self.value = value
    }
  }
}

func fo() {
  _ = ContentView(model: .init(MYPerson()))
}

struct ContentView: View {
//  @ObserableModel(MYPerson.self) var model

  @ObservableModel(MYPerson()) var model

  var body: some View {
    VStack {
      Text("name: \(model.name ?? "null")")

      Button("Change Name") {
        withAnimation {
          let cur = model.name ?? ""
          model.name = cur + "go_"
        }
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
