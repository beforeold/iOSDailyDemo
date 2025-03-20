import Foundation
import Observation
import Perception

@Observable
class Model {
  var name = "" {
    didSet {
      print("hello", name)
    }
  }
}

@Perceptible
class PModel {
  var name = "" {
    didSet {
      print("hello", name)
    }
  }
}

//do {
//  let model = Model()
//  model.name = "bo"
//}

do {
  let model = PModel()
  model.name = "bo"
}
