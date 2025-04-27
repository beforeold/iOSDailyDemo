import SwiftUI

class Model: ObservableObject {
  @Published var count = 0
}

struct ContentView: View {
  @StateObject private var model = Model()

  var body: some View {
    VStack {
      Text("count: \(model.count)")

      Button("Plus") {
        model.count += 1
      }
    }
    .task {
      let stream = model.$count.values.toAsyncStream()

      for await item in stream {
        print("stream value", item)
      }
    }
  }
}

#Preview {
  ContentView()
}

/// erase type, see https://stackoverflow.com/questions/71749396/type-erasure-in-swift-concurrency-asyncstream
extension AsyncSequence {
  public func toAsyncThrowingStream() -> AsyncThrowingStream<Element, Error> {
    var asyncIterator = self.makeAsyncIterator()
    return AsyncThrowingStream<Element, Error> {
      try await asyncIterator.next()
    }
  }

  public func toAsyncStream() -> AsyncStream<Element> {
    var asyncIterator = self.makeAsyncIterator()
    return AsyncStream<Element> {
      try? await asyncIterator.next()
    }
  }
}
