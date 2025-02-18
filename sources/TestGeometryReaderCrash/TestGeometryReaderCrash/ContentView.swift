import ObservationBP
import SwiftUI

struct ContentView: ViewBP {
  @State private var object = NSObject()
  @State private var isLoading = true
  @State private var showsScrollView = true

  var bodyBP: some View {
    NavigationView {
      VStack(spacing: 30) {
        Button("reset") {
//          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            showsScrollView.toggle()
//          }
        }

        if isLoading {
          ProgressView()
        }

        NavigationLink("Push") {
          Text("Detail")
        }

        if showsScrollView {
//          ScrollView {
            VStack {
              Text("Hello")
                .frame(width: 320, height: 30)
                .background(footer())
            }
//          }
        } else {
          Text("No ScrollView")
        }

        Spacer()
      }
      .padding()
    }
  }

  func footer() -> some View {
    GeometryReader { geo in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//      DispatchQueue.main.async {
        let minY = geo.frame(in: .global).maxY
        print("delay", "frame: \(Int(minY))", "isLoading: \(isLoading)")
        isLoading = true
      }

      return Color.clear
    }
    .stacked()

//    AsyncGeoReader { geo in
//      let minY = geo.frame(in: .global).minY
//      print("delay", "frame: \(Int(minY))", "isLoading: \(isLoading)")
//      isLoading = false
//    }
  }
}

struct ObjectView: View {
  class Object {
    deinit {
      print("object deinit")
    }
  }

  @State private var object = Object()

  var body: some View {
    Text("object")
  }
}

extension View {
  func stacked() -> some View {
    ZStack {
      self

      ObjectView()
    }
  }
}

struct AsyncGeoReader: View {
  // @StateObject private var object = AsObservableObject(value: NSObject())
  @State private var object = NSObject()

  var update: (GeometryProxy) -> Void

  var body: some View {
    GeometryReader { [weak object] geo -> Color in
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      DispatchQueue.main.async {
        if object == nil {
          print("object is nil ===============")
          return
        }

        update(geo)
      }

      return Color.clear
    }
  }
}

/// turn a value to ObservableObject which can be used in SwiftUi view
public final class AsObservableObject<T>: ObservableObject {
  public let value: T

  public init(value: T) {
    self.value = value
  }
}

#Preview {
  ContentView()
}
