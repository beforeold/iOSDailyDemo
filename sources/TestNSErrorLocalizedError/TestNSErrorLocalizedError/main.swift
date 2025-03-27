import Foundation

let error = NSError(
  domain: "test",
  code: 666,
  userInfo: [NSLocalizedDescriptionKey: "出错了"]
)
print("error is LocalizedError", error is LocalizedError)
print("error, localizedDescription", error.localizedDescription)
print("error", error)

enum MyError: Error {
  case failed
}

let customError = MyError.failed
print("customError.localizedDescription", customError.localizedDescription)
print("customError", customError)
