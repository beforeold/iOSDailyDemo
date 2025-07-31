import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(spacing: 20) {

      Color.blue
        .frame(width: 4, height: 4)
        .clipShape(Circle())

      Wrapper()
        .frame(width: 4, height: 4)
    }
    .padding()
  }
}

struct Wrapper: UIViewRepresentable {
  func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    view.backgroundColor = .red
    view.layer.cornerRadius = 2

    return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {

  }
}

#Preview {
  ContentView()
}
