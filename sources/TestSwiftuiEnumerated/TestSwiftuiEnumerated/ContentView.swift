import SwiftUI

struct Model: Identifiable {
  var id: Int
}

struct ContentView: View {
  var data: [Model] = [.init(id: 666)]

  var body: some View {
    let _ = print("hello body")

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
    .background(Color.gray)
  }
}

#Preview {
  ContentView(data: [.init(id: 5)])
}
