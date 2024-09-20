import MacrosPackage

do {

  let a = 17
  let b = 25

  let (result, code) = #stringify(a * b)

  print("The value \(result) was produced by the code \"\(code)\"")
}

do {
  let (result, code) = #stringify(5)
  print("The value \(result) was produced by the code \"\(code)\"")
}

do {
  let value = #simpleMacro()
  print(value)
}
