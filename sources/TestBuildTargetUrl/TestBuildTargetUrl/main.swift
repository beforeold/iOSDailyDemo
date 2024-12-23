import Foundation

struct EventHelper {
  public static func buildTargetUrl(_ urls: [String?]?) -> String? {
    guard let urls else { return nil }
    if urls.isEmpty { return nil }
    if urls.count == 1 { return urls[0] }

    // more than one
    let map: [String: String?] = urls.enumerated().reduce(into: [String: String?]()) { partialResult, tuple in
      let key = "target\(tuple.offset + 1)_url"
      partialResult[key] = tuple.element
    }
    return map.jsonString()
  }
}

extension Dictionary {
  fileprivate func jsonString(prettify: Bool = false) -> String? {
    guard JSONSerialization.isValidJSONObject(self) else { return nil }
    let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
    guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
    return String(data: jsonData, encoding: .utf8)
  }
}

let string = EventHelper.buildTargetUrl([nil, nil, "ok"])
print(string ?? "null")
