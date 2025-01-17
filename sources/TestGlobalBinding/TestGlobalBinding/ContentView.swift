import SwiftUI

var globalBinding: Binding<Int>?

class Model: ObservableObject {
  @Published var count = 0
}

struct ContentView: View {
  @ObservedObject var model = Model()

  var body: some View {
    VStack(spacing: 30) {
      Text("count: \(model.count)")

//      SubView(count: $model.count)
      ButtonWrapper(count: $model.count)
//        .id(model.count)
    }
    .padding()
  }
}


struct ButtonWrapper: UIViewRepresentable {
  @Binding var count: Int

  func makeCoordinator() -> Coordinator {
    let ins = Coordinator(count: _count, parent: self)
    print(#function)
    return ins
  }

  func makeUIView(context: Context) -> UIButton {
    UIButton(primaryAction: .init(title: "Plus", handler: { _ in
      print("tap: \(context.coordinator.count)", "current", self.count)

//      count += 1
      context.coordinator.parent.count += 1
    }))
  }

  func updateUIView(_ uiView: UIButton, context: Context) {
    print("updateui", context.coordinator.count, "current:", self.count, "value", context.coordinator.parent.count)

  }

  class Coordinator {
    @Binding var count: Int
    var parent: ButtonWrapper

//    var count: Binding<Int>? {
//      Coordinator.count
//    }

    init(count: Binding<Int>, parent: ButtonWrapper) {
//      Coordinator.count = count
      self._count = .init(projectedValue: count)
//      self.countValue = countValue
      self.parent = parent
    }
  }
}


struct SubView: View {
  @Binding var count: Int

  var body: some View {
    Button("plus") {
      count += 1
    }

    .onAppear {
      if globalBinding == nil {
        globalBinding = $count
      } else {
        print("appear: \(count)")
      }
    }
  }
}

#Preview {
  ContentView()
}
