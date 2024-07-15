import SwiftUI

@MainActor
struct InputView: View {
  @ObservedObject var appViewModel: AppViewModel

  var body: some View {
    VStack {
      TextEditor(text: $appViewModel.text)
        .border(.gray)

      Button("Show Content") {
        appViewModel.showContent()
      }
      .disabled(appViewModel.text.isEmpty)
    }
    .padding()
  }
}

#Preview {
  InputView(appViewModel: .init())
}
