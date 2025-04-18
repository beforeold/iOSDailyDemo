import Foundation

struct Unchecked<T>: @unchecked Sendable {
  var value: T
}

extension NotificationCenter {
  @MainActor
  func postOnMain(_ note: Notification) {
    self.post(note)
  }

  func postOnMainWithQueue(_ note: Notification) {
    let unchecked = Unchecked(value: note)
    OperationQueue.main.addOperation {
      self.post(unchecked.value)
    }
  }
}

func foo() {
  Task { @MainActor in
    NotificationCenter.default.postOnMain(.init(name: Notification.Name(rawValue: "ww")))
  }
}
