import SwiftUI

struct TestChildView: View {
  @State var msg: String = ""
  var body: some View {
    VStack {
      Button(
        action: {
          self.msg = "Hallo World"
        },
        label: {
          Text("Say Hallo")
        }
      )

      ChildView(
        msg: msg
      ) {

      }
      .padding()
      .background(Color.orange)

      Text(msg)
        .padding()
        .background(Color.green)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ChildView: View {
  // @Binding
  var msg: String
  var action: () -> Void

  var body: some View {
    Text(msg)
      .onChange(of: msg) { value in
        print("changed", value)
      }
  }
}

#Preview {
  NavigationStack {
    TestChildView()
  }
}
