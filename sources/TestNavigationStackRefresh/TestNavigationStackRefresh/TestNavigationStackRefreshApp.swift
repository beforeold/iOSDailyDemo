import SwiftUI

class Navigator {
  var onPathChanged: ([String]) -> () = { _ in }
  var path: [String] = [] {
    didSet {
      onPathChanged(path)
    }
  }

  static let shared: Navigator = .init()

}

@main
struct TestNavigationStackRefreshApp: App {
  @State private var path: [String] = []

  init() {
    Navigator.shared.onPathChanged = { [_path] path in
      print(path)
      _path.wrappedValue = path
      print(_path.wrappedValue)
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView(path: $path)
    }
  }
}
