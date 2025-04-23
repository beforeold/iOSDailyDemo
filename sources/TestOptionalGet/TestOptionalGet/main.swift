import Foundation

struct MyError: Error {

}

extension Optional {
  func get() throws(MyError) -> Wrapped {
    if let ret = self {
      return ret
    }
    throw MyError()
  }
}

extension Result {
  func foo(a: Int) throws(Failure) {
    let value = try get()
    print(value)
  }
}

do {
  let value: Int? = 5
  let ret = try value.get()
  print("success", ret)
} catch {
  print("failed", error)
}

do {
  let value: Int? = nil
  let ret = try value.get()
  print("success", ret)
} catch {
  print("failed", error)
}
