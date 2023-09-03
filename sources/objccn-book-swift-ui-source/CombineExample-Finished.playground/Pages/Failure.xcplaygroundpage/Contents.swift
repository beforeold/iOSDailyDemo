import Combine
import Foundation

enum MyError: Error {
    case myError
}

check("Fail") {
    Fail<Int, SampleError>(error: .sampleError)
}

check("Map Error") {
    Fail<Int, SampleError>(error: .sampleError)
        .mapError { _ in MyError.myError }
}

check("Throw") {
    ["1", "2", "Swift", "4"].publisher
        .tryMap { s -> Int in
            guard let value = Int(s) else {
                throw MyError.myError
            }
            return value
        }
}

check("Replace Error") {
    ["1", "2", "Swift", "4"].publisher
        .tryMap { s -> Int in
            guard let value = Int(s) else {
                throw MyError.myError
            }
            return value
        }
        .replaceError(with: -1)
}

check("Catch with Just") {
    ["1", "2", "Swift", "4"].publisher
        .tryMap { s -> Int in
            guard let value = Int(s) else {
                throw MyError.myError
            }
            return value
        }
        .catch { _ in Just(-1) }
}

check("Catch with Another Publisher") {
    ["1", "2", "Swift", "4"].publisher
        .tryMap { s -> Int in
            guard let value = Int(s) else {
                throw MyError.myError
            }
            return value
        }
        .catch { _ in [-1, -2, -3].publisher }
}

check("Catch and Continue") {
    ["1", "2", "Swift", "4"].publisher
        .print("[Original]")
        .flatMap { s in
            return Just(s)
                .tryMap { s -> Int in
                    guard let value = Int(s) else {
                        throw MyError.myError
                    }
                    return value
                }
                .print("[TryMap]")
                .catch { _ in
                    Just(-1).print("[Just]") }
                .print("[Catch]")
        }
}
