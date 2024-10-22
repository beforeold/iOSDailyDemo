import Foundation

func foo() {
  let range = 0..<0
  for i in range {
    print(i)
  }
}

func bar() {
  var int = -1
  let range = 0..<int
  for i in range {
    print(i)
  }
}

foo()
bar()

print("Hello, World!")

