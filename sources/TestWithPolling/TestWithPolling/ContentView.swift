import SwiftUI

struct ContentView: View {
  @StateObject private var vm = ViewModel()

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

@MainActor
class ViewModel: ObservableObject {
  @Published var count = 0

  init() {
    print("init vm")

    Task {
      await polling()
    }
  }

  func polling() async {
    do {
      var count = 0
      let ret = try await withPolling(
        stops: { isValie($0) },
        gap: { try await Task.sleep(nanoseconds: 1_000_000_000) },
        task: {
          count += 1
          print("hello", count)

          return count
        }
      )
      print("result", ret)
    } catch {
      print("result error", error)
    }
  }

  func isValie(_ value: Int) -> Bool {
    print(Thread.current)
    return value > 10
  }
}

/// 轮询直到结果满足要求
/// - Parameters:
///   - gap: 间隔时间
///   - stops: 判断结果满足要求后停止
///   - task: 任务
/// - Throws: 原 task 和 gap 错误
/// - Returns: 最终的 value
public func withPolling<T>(
  stops: (T) async -> Bool,
  gap: () async throws -> Void,
  task: () async throws -> T
) async rethrows -> T {
  while true {
    let value = try await task()
    if await stops(value) {
      return value
    }

    try await gap()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
