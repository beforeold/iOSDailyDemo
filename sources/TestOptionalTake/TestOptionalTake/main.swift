import Foundation

var string: String? = "ok"
let value = string.take()
print("takend value", value ?? "null")
print("after takend value", string ?? "null")

