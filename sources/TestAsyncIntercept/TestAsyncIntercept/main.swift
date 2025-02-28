import Foundation

print("Hello, World!")


// 1. 定义核心协议
protocol AsyncInterceptor {
  func intercept<T>(_ task: @escaping () async throws -> T) -> () async throws -> T
}

// 2. 实现 KMP 异常拦截器（默认自带）
struct KMPInterceptor: AsyncInterceptor {
  let api: String

  func intercept<T>(_ task: @escaping () async throws -> T) -> () async throws -> T {
    return {
      print("[\(self.api)] Start")
      defer { print("[\(self.api)] End") }

      do {
        return try await task()
      } catch {
        print("[\(self.api)] Error: \(error)")
        throw error
      }
    }
  }
}

// 3. 重构 step 构建器
struct AsyncStep<T> {
  private let task: () async throws -> T
  private var interceptors: [any AsyncInterceptor] = []

  init(_ task: @escaping @autoclosure () async throws -> T) async {
    self.task = task
  }

  func add(interceptor: some AsyncInterceptor) -> AsyncStep {
    var copy = self
    copy.interceptors.append(interceptor)
    return copy
  }

  func execute() async throws -> T {
    let initialTask = self.task
    return try await interceptors.reversed().reduce(initialTask) { task, interceptor in
      interceptor.intercept(task)
    }()
  }
}

// 4. 链式 DSL 扩展
extension AsyncStep {
  func klog(api: String) -> AsyncStep {
    self.add(interceptor: KMPInterceptor(api: api))
  }

  //    func intercept(_ handler: @escaping (() async throws -> Any) -> () async throws -> Any) -> AsyncStep {
  //        self.add(interceptor: CustomInterceptor(handler: handler))
  //    }
}

// 5. 自定义拦截器封装
struct CustomInterceptor: AsyncInterceptor {
  let handler: (() async throws -> Any) -> () async throws -> Any

  func intercept(
    _ task: @escaping () async throws -> T
  ) -> () async throws -> T {
    return {
        print("[\(self.api)] Start")
        defer { print("[\(self.api)] End") }

        do {
            return try await task()
        } catch {
            print("[\(self.api)] Error: \(error)")
            throw error
        }
    }
  }
}

// 使用示例

func foo() async throws {
  let model = try await AsyncStep(
    try await GenerateRepository().generateHD(params: .init(taskId: ""))
  )
  .klog(api: "hd")
  //    .intercept { task in
  //        {
  //            try await interceptForSubscriptionIfPossible {
  //                try await task()
  //            }
  //        }
  //    }
  .execute()

}

func test() async throws -> String {
  "he"
}


