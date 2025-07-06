import SwiftUI

struct RollPanel: View {
  @Environment(\.dismiss) var dismiss

  @State var sarah: Int?
  @State var brook: Int?

  var completion:
    (
      _ sarah: Int,
      _ brook: Int
    ) -> Void = { _, _ in }

  var body: some View {
    VStack(spacing: 40) {
      Text("力量摇点")
        .font(.title)

      HStack(spacing: 50) {
        RollView(
          name: "Sarah",
          completion: {
            print("sarah power", $0)
            sarah = $0
          }
        )
        .tint(.yellow)

        RollView(
          name: "Brook",
          completion: {
            print("brook power", $0)
            brook = $0
          }
        )
        .tint(.red)
      }

      Button("完成") {
        dismiss()
        completion(sarah!, brook!)
      }
      .buttonStyle(.borderedProminent)
      .disabled(sarah == nil || brook == nil)
    }
  }
}

#Preview {
  RollPanel()
}
