import Foundation

public extension NSNumber {
  func formatToBigNumber(locale: Locale = .current) -> String {
    let formatter = NumberFormatter()
     formatter.locale = locale  // 指定为沙特阿拉伯地区
//    formatter.locale = Locale(identifier: "de_DE")  // 指定为德国
//    formatter.locale = Locale(identifier: "en_US")  // 指定为美国

    // formatter.numberStyle = .currency
    formatter.numberStyle = .decimal
//    formatter.maximumFractionDigits = 2 // Adjust the number of fraction digits as needed
//    formatter.usesGroupingSeparator = true

    if let formattedNumber = formatter.string(from: self) {
      return formattedNumber
    } else {
      return self.description
    }
  }
}

let number = 12345.67
print(number, (number as NSNumber).formatToBigNumber(locale: Locale(identifier: "en_US")))
print(number, (number as NSNumber).formatToBigNumber(locale: Locale(identifier: "de_DE")))
print(number, (number as NSNumber).formatToBigNumber(locale: Locale(identifier: "ar_SA")))

print("\n")

print(Locale.current)
print(Locale.current.currency ?? "null")
print("\n")

print(number, number.formatted())

