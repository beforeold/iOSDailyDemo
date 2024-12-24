import SwiftUI

struct WrapperView<Content, PanelContent>: UIViewControllerRepresentable where Content: View, PanelContent: View {
  var content: () -> Content
  var panelContent: () -> PanelContent

  init(
    content: Content,
    @ViewBuilder panelContent: @escaping () -> PanelContent
  ) {
    self.content = { content }
    self.panelContent = panelContent
  }

  func makeUIViewController(context: Context) -> UIHostingController<Content> {
    UIHostingController(rootView: content())
  }

  func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
    print(#function)
    uiViewController.rootView = content()
  }

  //  var body: some View {
  //    VStack {
  //      content()
  //
  //      panelContent()
  //    }
  //  }

}

struct TestChild2View: View {
  @State var msg: String = ""
  var body: some View {
    VStack {
      Button(
        action: {
          withAnimation {
            self.msg = "Hallo World"
          }
        },
        label: {
          Text("Say Hallo")
        }
      )

      WrapperView(
        content: child,
        panelContent: {
          Text("panel content")
        }
      )
      .frame(height: 200)

      Text(msg)
        .padding()
        .background(Color.green)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var child: some View {
    Child2View(msg: msg) {}
      .padding()
      .background(Color.orange)
  }
}

struct Child2View: View {
  // @Binding
  var msg: String
  var action: () -> Void

  var body: some View {
    Text(msg)
  }
}

#Preview {
  NavigationStack {
    TestChild2View()
  }
}
