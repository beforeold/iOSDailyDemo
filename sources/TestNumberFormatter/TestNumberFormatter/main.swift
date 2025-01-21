import Foundation

let number: NSNumber = 1234567.89

// Create a NumberFormatter instance
let numberFormatter = NumberFormatter()
numberFormatter.numberStyle = .decimal  // You can choose other styles like .currency, .percent, etc.

// Localize the number based on the current locale
if let localizedNumber = numberFormatter.string(from: number) {
  print("Localized Number: \(localizedNumber)")

} else {
  print("failed to format")
}

numberFormatter.locale = Locale(identifier: "de_DE") // Set to German locale

// Localize the number based on the current locale
if let localizedNumber = numberFormatter.string(from: number) {
  print("Localized Number: \(localizedNumber)")

} else {
  print("failed to format")
}
