import SwiftUI

struct ContentView: View {
  // Example usage
  let taskQueue = TaskQueue()

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .task {
      await taskQueue.enqueue(priority: .low) {
        print("Low priority task started")
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        print("Low priority task completed")
      }

      await taskQueue.enqueue(priority: .medium) {
        print("Medium priority task started")
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        print("Medium priority task completed")
      }

      await taskQueue.enqueue(priority: .high) {
        print("High priority task started")
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        print("High priority task completed")
      }


    }
  }
}

#Preview {
  ContentView()
}

import Foundation

enum TaskPriority: Int, Comparable {
  case high = 3
  case medium = 2
  case low = 1

  static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

actor TaskQueue {
  private var tasks: [(priority: TaskPriority, task: () async -> Void)] = []
  private var isRunning = false

  func enqueue(priority: TaskPriority, _ task: @escaping () async -> Void) {
    tasks.append((priority, task))
    tasks.sort { $0.priority > $1.priority } // Sort by priority (high to low)
    runNextTaskIfNeeded()
  }

  private func runNextTaskIfNeeded() {
    guard !isRunning, !tasks.isEmpty else { return }
    isRunning = true

    Task {
      while !tasks.isEmpty {
        let nextTask = tasks.removeFirst().task
        await nextTask()
      }
      isRunning = false
    }
  }
}
