import SwiftData
import SwiftUI

struct SnackModifier: PreviewModifier {
  static func makeSharedContext() throws -> ModelContainer {
    print(#function)

    let container = try ModelContainer(for: Snack.self)
    container.mainContext.insert(Snack(name: "br: \(Int.random(in: 0..<1000))"))

    return container
  }

  func body(content: Content, context: ModelContainer) -> some View {
    // print(context.mainContext)
    return content.modelContainer(context)
  }
}
