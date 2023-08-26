//
//  main.swift
//  TestTaskGlobal
//
//  Created by Brook_Mobius on 8/26/23.
//

import Foundation

extension Task where Success == Never, Failure == Never {
  static func dispatch<T>(work: @escaping () -> T) async -> T  {
    await withCheckedContinuation { continuation in
      DispatchQueue.global().async {
        let ret = work()
        continuation.resume(with: .success(ret))
      }
    }
  }
}

extension DispatchQueue {
  func withThrowingContinuation<T>(
    execute work: @escaping () throws -> T
  ) async throws -> T  {
    try await withCheckedThrowingContinuation { continuation in
      self.async {
        do {
          let ret = try work()
          continuation.resume(returning: ret)
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func withContinuation<T>(
    execute work: @escaping () -> T
  ) async -> T  {
    await withCheckedContinuation { continuation in
      self.async {
        let ret = work()
        continuation.resume(returning: ret)
      }
    }
  }
}

func loadBigFile() -> String {
  Thread.sleep(forTimeInterval: 1)
  return "The Target File is Loaded"
}

func foo() async throws {
  let string = await DispatchQueue.global().withContinuation {
    loadBigFile()
  }
  print("result", string, separator: ": ")
}


func main() {
  print("=== begin")
  
  print("block begin")
  Task {
    print("task begin")
    do {
      try await foo()
    } catch {
      print("task error")
    }
    print("task end")
  }
  print("block end")
  
  Thread.sleep(forTimeInterval: 2)
  
  print("=== end")
}

main()
