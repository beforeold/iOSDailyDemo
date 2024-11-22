import SwiftUI
import App

class Router: ObservableObject {
  @State var path: [String] = []
}

struct ObserableView<Content: View>: View {
  @ViewBuilder
  var content: () -> Content

  var body: some View {
    content()
  }
}

@Observable
class Router2 {
  var path: [String] = []

  func binding() -> Binding<[String]> {
    return Bindable(self).path
  }
}

//import Perception
//@Perceptible
//class Router3 {
//  var path: [String] = []
//}

struct ContentView: View {
     @Binding var path: [String]
//   @State private var path: [String] = []
  //  @BindableBP var router: Router3 = .init()
//  @Bindable var router: Router2 = .init()
//     @StateObject private var router: Router = .init()
  //   @Perception.Bindable var router: Router3 = .init()

  var body: some View {
    let _ = print("body")
    //    WithPerceptionTracking {
//        NavigationStack(path: $path) {
    NavigationStack(path: $path) {
      let _ = print("root view")
      InnerView {
//        router.path = ["hello"]
//                  path = ["hello"]
        Navigator.shared.path.append("hello2")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
          print("timer")
//          path.append("hello2")
        }
      }

    }
    //    }
  }
}

@Observable
class InnerModel {
  var value = "hello"

  init() {
    print("init InnerModel")
  }

  deinit {
    print("deinit InnerModel")
  }
}

struct InnerView: View {
  @State var innerModel = InnerModel()

  var action: () -> Void

  var body: some View {
    VStack {
      Button("push") {
        action()
      }
    }
    .padding()
    .navigationDestination(for: String.self) { value in
      Text("result: \(value)")
    }
  }
}

#Preview {
  ContentView(path: .constant([]))
}

//
//@propertyWrapper
//@dynamicMemberLookup
//public struct BindableBP<Value> where Value: AnyObject, Value: Perceptible {
//  public var wrappedValue: Value
//
//  public init(wrappedValue: Value) {
//    self.wrappedValue = wrappedValue
//  }
//
//  public var projectedValue: BindableBP<Value> {
//    self
//  }
//
//  public subscript<Subject>(
//    dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>
//  ) -> Binding<Subject> {
//    return Binding<Subject>(
//      get: {
//        print("bindable get")
//        return self.wrappedValue[keyPath: keyPath]
//      },
//      set: { value in
//        print("bindable set", value)
//        self.wrappedValue[keyPath: keyPath] = value
//      }
//    )
//  }
//}
