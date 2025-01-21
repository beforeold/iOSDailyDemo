import Foundation
import SwiftData

@Model
class Snack {
  var name = ""

  static var potatoChips: Snack {
    Snack(name: "br")
  }

  init(name: String = "") {
    self.name = name
  }
}
