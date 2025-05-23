import Foundation

func foo() throws {
  print("begin")

  defer {
    print("end")
  }
  throw NSError(domain: "test", code: -1)
}

do {
  try foo()
} catch {
  print("failed", error)
}
