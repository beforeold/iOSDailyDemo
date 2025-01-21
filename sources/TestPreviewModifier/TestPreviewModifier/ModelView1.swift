import SwiftUI

class Model: NSObject, ObservableObject {
  @Published var age = 0

  init(age: Int = .random(in: 0..<100)) {
    self.age = age
  }
}

struct ModelModifier: PreviewModifier {
  static func makeSharedContext() async throws -> Model {
    print(#function)

    try await Task.sleep(for: .seconds(1))

    return Model()
  }

  func body(content: Content, context: Model) -> some View {
    print("body", context)
    return content.environmentObject(context)
  }
}

struct ModelView1: View {
  @EnvironmentObject private var model: Model

  var body: some View {
    Text("ModelView1: \(model.age)")
  }
}

#Preview(traits: .modifier(ModelModifier())) {
  ModelView1()
}

#Preview(traits: .modifier(ModelModifier())) {
  ModelView1()
}
