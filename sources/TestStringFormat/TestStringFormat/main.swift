import Foundation

let format1 = "value: %s"
print(
  String(
    format: format1,
    ("hello" as NSString).cString(using: String.Encoding.utf8.rawValue)!
  )
)

let format2 = "value: %@"
print(String(format: format2, "hello"))
