import SwiftUI

struct ContentView: View {
  @State private var status: String = "init"

  var body: some View {
    VStack(spacing: 30) {
      Button("Update") {
        status = "updated"
      }

      SubView(status: status)
        //        .task(id: status) {
        //          print("task status: \(status)")
        //        }
//        .onAppear(id: status) {
//          print("appear \(status)")
//        }
        .modifier(OnAppearWithIDModifier2(id: status, action: {
          print("onappear 2", status)
        }))
    }
    .padding()
  }
}

struct SubView: View {
  let status: String

  var body: some View {
    print("subvew body")

    return Text("status: \(status)").onChange(of: status) {
      print("on change of ", $0)
    }
  }
}

// 1. Define the View Extension
extension View {
  /// Executes an action when the view appears or when the provided id changes.
  /// - Parameters:
  ///   - id: An identifier that triggers the action when it changes.
  ///   - action: The closure to execute.
  /// - Returns: A view that triggers the action based on appearance and id changes.
  func onAppear<ID: Equatable>(id: ID, perform action: @escaping () -> Void) -> some View {
    modifier(OnAppearWithIDModifier(id: id, action: action))
  }
}

// 2. Create the Custom View Modifier
struct OnAppearWithIDModifier<ID: Equatable>: ViewModifier {
  let id: ID
  let action: () -> Void

  @State private var currentID: ID?

  func body(content: Content) -> some View {
    content
      .onAppear {
        print("onappea of")
        // Check if the current ID is different or not set
        if currentID != id {
          currentID = id
          action()
        }
      }
      .onChange(of: id) { newID in
        print("onchange of")
        if currentID != newID {
          currentID = newID
          action()
        }
      }
  }
}


// 2. Create the Custom View Modifier
struct OnAppearWithIDModifier2<ID: Hashable>: ViewModifier {
  let id: ID
  let action: () -> Void

  func body(content: Content) -> some View {
    content
      .overlay {
        Color.black
          .opacity(0.001)
          .frame(width: 1, height: 1)
          .onAppear {
            action()
          }
          .id(id)
      }
  }
}

#Preview {
  ContentView()
}
