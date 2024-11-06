import SwiftUI

public struct Content {
  public init() {}
}

extension Content: View {
  var body: some View {
    Text("hello 2233")
      .onAppear {
        //        Host.foo()
      }
  }
}

#Preview {
  Content()
}
