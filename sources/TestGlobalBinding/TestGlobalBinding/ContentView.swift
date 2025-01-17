import SwiftUI

class Model: ObservableObject {
  @Published var count = 0
}

struct ContentView: View {
  @ObservedObject var model = Model()

  var body: some View {
    VStack(spacing: 30) {
      Text("count: \(model.count)")

      ButtonWrapper(count: $model.count)
        .frame(height: 100)
    }
    .padding()
  }
}

struct ButtonWrapper: UIViewRepresentable {
  @Binding var count: Int

  func makeCoordinator() -> Coordinator {
    let ins = Coordinator(count: $count)
    print(#function)

    return ins
  }

  func makeUIView(context: Context) -> UIButton {
    UIButton(
      primaryAction: .init(
        title: "Plus",
        handler: { _ in
          print("tap context: \(context.coordinator.count)", "current", self.count)

          count += 1
        }))
  }

  func updateUIView(_ uiView: UIButton, context: Context) {
    print("updateUIView context", context.coordinator.count, "current:", self.count, "value", count)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      print("delay updateUIView context", context.coordinator.count, "current:", self.count, "value", count)
    }
  }

  class Coordinator {
    @Binding var count: Int

    init(count: Binding<Int>) {
      self._count = .init(projectedValue: count)
    }
  }
}

#Preview {
  ContentView()
}
