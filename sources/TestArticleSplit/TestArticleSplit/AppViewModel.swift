import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
  @AppStorage("content_text") var text: String = ""

  @Published var navigationPath: NavigationPath = . init()

  func showContent() {
    navigationPath.append(
      Content(text: text)
    )
  }
}
