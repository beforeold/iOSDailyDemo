import SwiftData
import SwiftUI

struct SnackView: View {
  var snack: Snack

  var body: some View {
    Text(snack.name + "same")
  }
}

#Preview(traits: .modifier(SnackModifier())) {
  @Previewable @Query var snacks: [Snack]
  print("count", snacks.count)

  return SnackView(snack: snacks.first!)
}
