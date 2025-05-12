import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

struct PopoverExample: View {
  @State private var isShowingPopover = false

  var body: some View {
    Button("Show Popover") {
      self.isShowingPopover = true
    }
    .popover(
      isPresented: $isShowingPopover,
      arrowEdge: .top
    ) {
      Text("Popover Content")
        .padding()
        .popes()
    }
  }
}

extension View {
  @ViewBuilder
  func popes() -> some View {
    if #available(iOS 16.4, *) {
      self.presentationCompactAdaptation((.popover))
    } else {
      self
    }
  }
}

#Preview {
  PopoverExample()
}
