import Foundation

enum First: String, Codable {
  case hello
}

struct Second: RawRepresentable, Decodable {
  init(rawValue: String) {
    self.rawValue = rawValue
  }

  var rawValue: String

  typealias RawValue = String

  static let hello = Second(rawValue: "hello")
}

func test() throws {
  let encoded = try JSONEncoder().encode(First.hello)
  let decoded = try JSONDecoder().decode(Second.self, from: encoded)
  print("result", decoded)
}

do {
  try test()
} catch {
  print("error", error)
}
