import SwiftUI

struct OnceTaskModifier: ViewModifier {
  @State private var once = false
  private let task: () async -> Void

  init(task: @escaping () async -> Void) {
    self.task = task
  }

  func body(content: Content) -> some View {
    content.task {
      if once {
        print("once return")
        return
      } else {
        print("once begin")
        once = true
        await task()
        print("once end")
      }
    }
  }
}

extension View {
  func onceTask(task: @escaping () async -> Void) -> some View {
    modifier(OnceTaskModifier(task: task))
  }
}
