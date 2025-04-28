import Combine
import SwiftUI

class Model: ObservableObject {
  @Published var count = 0
}

struct ContentView: View {
  @StateObject private var model = Model()

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .task {
      await bar()
    }
  }

  func foo() async {
    let observable = ObservableObjectPublisher()
    Task {
      try await Task.sleep(nanoseconds: 1_000_000)
      observable.send()
      observable.send()
    }
    let buffer = observable.buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
    // let pub = buffer
    let pub = observable
    let first: Any? = await AsyncPublisher(pub).first(where: { _ in true })
    print("first", first ?? "null")
  }

  func bar() async {
    let observable = model.$count
    Task {
      try await Task.sleep(nanoseconds: 1_000_000)
      model.count += 1
      model.count += 1
    }
    let buffer = observable.buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
    // let pub = buffer
    let pub = observable
    let first: Any? = await pub.values.toAsyncStream().first(where: { _ in true })
    print("first", first ?? "null")
  }
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

#Preview {
  ContentView()
}
