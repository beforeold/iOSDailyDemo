import Foundation


do {
  // public var sceneCreditUnit: [ConfigKey: Double]
  struct ConfigKey: RawRepresentable, Codable, Hashable {
    public var rawValue: String
    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }

  let json = #"""
{
"key1": 1
}
"""#.data(using: .utf8)!

  // why cannot be [ConfigKey: Double]
  // let dict = try JSONDecoder().decode([String: Double].self, from: json)
  let dict = try JSONDecoder().decode([ConfigKey: Double].self, from: json)
  print("dict", dict)

  let dictString = try JSONDecoder().decode([String: Double].self, from: json)
  print("dictString", dictString)
} catch {
  print("dictString", error)
}

do {
  // 以及 [String: Config] 的解析
}
