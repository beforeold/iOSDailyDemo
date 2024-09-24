import SwiftUI

@Observable
class Model {
  var name: String = ""
}

struct SwiftUIView: View {
  var body: some View {
    Text("Hello, World! \(Model().name)")
  }
}

#Preview {
  SwiftUIView()
}
