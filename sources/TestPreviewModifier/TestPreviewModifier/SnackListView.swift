import SwiftData
import SwiftUI

struct SnackListView: View {
  @Query private var snacks: [Snack]

  var body: some View {
    ForEach(snacks, id: \.self) { snack in
      SnackView(snack: snack)
    }
  }
}

#Preview(traits: .modifier(SnackModifier())) {
  SnackListView()
}
