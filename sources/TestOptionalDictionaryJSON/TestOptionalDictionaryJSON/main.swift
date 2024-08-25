import Foundation

enum Some {

}

let dictionary: [String: Any] = ["string": Optional<Int>.none as Any]

JSONPrinter.print(dictionary)

do {
  let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
  let string = String(decoding: jsonData, as: UTF8.self)
  print("success", string)
} catch {
  print("failed", error)
}
