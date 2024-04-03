//
//  ContentView.swift
//  TestAsyncSequenceSideEffet
//
//  Created by Brook_Mobius on 4/3/24.
//

import SwiftUI

struct SideEffectAsyncSequenceIterator<AS>: AsyncIteratorProtocol where AS: AsyncSequence {
  typealias Element = AS.Element

  var base: AS.AsyncIterator
  var block: (Element) async -> Void

  mutating func next() async throws -> Element? {
    let value = try await base.next()
    if let value {
      await block(value)
    }
    return value
  }
}

struct SideEffectAsyncSequence<AS>: AsyncSequence where AS: AsyncSequence {
  typealias AsyncIterator = SideEffectAsyncSequenceIterator<AS>

  typealias Element = AS.Element

  let base: AS
  let block: (Element) async -> Void

  func makeAsyncIterator() -> SideEffectAsyncSequenceIterator<AS> {
    SideEffectAsyncSequenceIterator(
      base: base.makeAsyncIterator(),
      block: block
    )
  }
}

extension AsyncSequence {
  func print() -> SideEffectAsyncSequence<Self> {
    hook { element in
      Swift.print("Got new value: \(element)")
    }
  }

  func hook(block: @escaping (Self.Element) async -> Void) -> SideEffectAsyncSequence<Self> {
    SideEffectAsyncSequence(base: self, block: block)
  }
}

class Model {
  func foo() async throws {
    let stream = AsyncStream { (continuation: AsyncStream<Int>.Continuation) in
      Task {
        let items = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        for item in items {
          continuation.yield(item)
          try? await Task.sleep(nanoseconds: 1000000)
        }
        continuation.finish()
      }
    }

    let seq = stream
      .prefix(5)
      .print()
      .filter { $0.isMultiple(of: 2) }

    for try await value in seq {
      print("Value:", value)
    }
  }
}

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
      Task {
        try? await Model().foo()
      }
    }
  }
}

#Preview {
  ContentView()
}
