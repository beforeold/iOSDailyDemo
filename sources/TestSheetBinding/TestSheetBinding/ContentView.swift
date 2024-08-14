import SwiftUI


class Model: ObservableObject {
  @Published var flag = false
}

@Observable
class Model2 {
  var flag = false
}

extension View {
  @ViewBuilder
  func sheet(isPresendted: Binding<Bool>, text: String) -> some View {
    let _ = print("sheet calculate text")

    self
      .sheet(isPresented: isPresendted) {
        let _ = print("make text")
        Text(text)
      }
  }
}

func getText() -> String {
  let _ = print("getText")
  return "hello"
}

struct ContentView: View {
//  @ObservedObject var model = Model()

  @Bindable var model = Model2()

  var body: some View {
    let _ = print("body")

    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .onTapGesture {
      model.flag = true
    }
    .sheet(
      isPresendted: $model.flag,
      text: getText()
    )
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
