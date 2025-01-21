import SwiftUI

struct ModelView2: View {
  @EnvironmentObject private var model: Model

  var body: some View {
    Text("ModelView2: \(model.age)")
  }
}

#Preview(traits: .modifier(ModelModifier())) {
  ModelView2()
}

#Preview(traits: .modifier(ModelModifier())) {
  ModelView2()
}
