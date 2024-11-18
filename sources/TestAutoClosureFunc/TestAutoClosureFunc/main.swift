import Foundation

func withClosure<T>(_ closure: () -> T) -> T {
  return closure()
}

func withAutoClosure<T>(_ closure: @autoclosure () -> T) -> T {
  return withClosure(closure)
}

print(withClosure({
  print("555")
  return 555
}))

print(withAutoClosure(555))
