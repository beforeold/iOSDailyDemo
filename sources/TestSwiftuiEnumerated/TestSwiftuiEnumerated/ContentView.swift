import SwiftUI

struct Model: Identifiable {
  var id: Int
}

struct ContentView: View {
  var data: [Model] = []

  var body: some View {
    List {
      // ForEach(data.enumerated().map, id: \.element.id) { index, element in
      ForEach(
        data.enumerated().map { $0 },
        id: \.element.id
      ) { index, element in
        Text("hello, id: \(index)")
      }
    }
    .padding()
  }
}

#Preview {
  ContentView(data: [.init(id: 5)])
}
