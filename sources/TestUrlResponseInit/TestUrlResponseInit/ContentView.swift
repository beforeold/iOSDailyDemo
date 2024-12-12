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
    .onAppear {
      let resp = HTTPURLResponse(
        url: URL(string: "http://www.baidu.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      print("instance", resp?.description ?? "null")
    }
  }
}

#Preview {
  ContentView()
}
