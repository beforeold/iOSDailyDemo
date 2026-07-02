import SwiftUI

enum Theme {
  static let ink = Color(red: 0.102, green: 0.098, blue: 0.082)
  static let clay = Color(red: 0.855, green: 0.467, blue: 0.337)
  static let paper = Color(red: 0.961, green: 0.945, blue: 0.918)
  static let card = Color(red: 0.922, green: 0.898, blue: 0.847)
  static let stone = Color(red: 0.529, green: 0.525, blue: 0.498)
  static let charcoal = Color(red: 0.239, green: 0.239, blue: 0.227)

  static let display = Font.system(.largeTitle, design: .serif).weight(.bold)
  static let sectionTitle = Font.system(.title3, design: .serif).weight(.semibold)
  static let body = Font.system(.subheadline, design: .default)
  static let mono = Font.system(.footnote, design: .monospaced)
  static let monoSmall = Font.system(.caption2, design: .monospaced)
}

struct ReceiptCard<Content: View>: View {
  let command: String
  let title: String
  @ViewBuilder var content: Content

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(title)
        .font(Theme.sectionTitle)
        .foregroundStyle(Theme.ink)

      content

      HStack(spacing: 6) {
        Text("$")
          .foregroundStyle(Theme.clay)
        Text(command)
          .foregroundStyle(Theme.stone)
      }
      .font(Theme.mono)
      .lineLimit(1)
      .minimumScaleFactor(0.8)
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Theme.card)
    .clipShape(RoundedRectangle(cornerRadius: 4))
    .overlay(
      RoundedRectangle(cornerRadius: 4)
        .strokeBorder(Theme.ink.opacity(0.08), lineWidth: 1)
    )
  }
}
