import SwiftUI

@MainActor
struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .task {
      let value: Int? = try? await withPolling(
        stops: { value in
          // return value > 5
          // return myStop(value)
          Task {
            let value = await self.myStop(5)
            print("task stop at?: ", value)
          }

          return value > 5
        },
        gap: { try await Task.sleep(nanoseconds: 1_000_000_000) },
        task: {
          print("task")
          return 5
        }
      )
      print("result value", value as Any)
    }
  }

  @MainActor
  private func myStop(_ value: Int) -> Bool {
    let vc = UIViewController()
    vc.view.addSubview(UILabel())

    print("hello")
    print(Thread.current)
    return false
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
  stops: @Sendable (T) -> Bool,
  gap: () async throws -> Void,
  task: () async throws -> T
) async rethrows -> T {
  while true {
    let value = try await task()
    if stops(value) {
      return value
    }

    try await gap()
  }
}

//@MainActor
class Handler {
  func foo(stop: () -> Void) async {
    stop()
  }
}

#Preview {
  ContentView()
}
