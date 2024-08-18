import SwiftUI


class Model: ObservableObject {
  @Published var flag = false
}

@Observable
class Model2 {
  var flag = false

  var name: String?
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

  @ViewBuilder
  func sheet(
    valuePresendted: Binding<String?>
  ) -> some View {
    let _ = print("sheet calculate text")

    self
      .sheet(isPresented: .init(
        get: { valuePresendted.wrappedValue != nil },
        set: { flag in valuePresendted.wrappedValue = nil } )
      ) {
        let _ = print("make text")
        Text(valuePresendted.wrappedValue!)
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
      //      model.flag = true
      model.name = "Brook_" + (0..<100).randomElement()!.description
    }
    .sheet(
      isPresendted: $model.flag,
      text: getText()
    )
    .sheet(
      valuePresendted: $model.name
    )
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
