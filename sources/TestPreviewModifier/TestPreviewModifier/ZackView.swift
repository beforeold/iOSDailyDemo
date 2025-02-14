import SwiftUI

struct ZackView: View {
  var body: some View {
    Text("ok i got it 123")
  }
}

class Zack: ObservableObject {
  init() {
    print("init zack 2 3")
  }
}

struct ZackModifier: PreviewModifier {
  @Environment(\.colorScheme) var colorScheme

  static func makeSharedContext() async throws -> Zack {
    print(#function)
    try await Task.sleep(for: .seconds(2))
    return Zack()
  }

  func body(content: Content, context: Zack) -> some View {
    print(#function, colorScheme)

    return content.environmentObject(context)
  }

}

#Preview("z1", traits: .modifier(ZackModifier())) {
  ZackView()
    .preferredColorScheme(.dark)
}

#Preview("z2", traits: .modifier(ZackModifier())) {
  ZackView()
}
