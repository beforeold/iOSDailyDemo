import Combine

check("Empty") {
    Empty<Int, SampleError>()
}

check("Just") {
    Just("Hello SwiftUI")
}

check("Pass") { () -> PassthroughSubject<Int, Never> in
    let p = PassthroughSubject<Int, Never>()
    defer {
        p.send(5)
    }
    return p
}


Global.cancel = check("TryMap2") {
    createTryMap2()
}

check("TryMap") {
    createTryMap1()
}


enum MyError: Error {
    case myError
}

func createTryMap1() -> some Publisher {
    let publisher = ["1", "2", "Swift", "4"]
        .publisher
        .tryMap { s -> Int in
            guard let value = Int(s) else {
                throw MyError.myError
            }
            return value
        }
    return publisher
}



struct ParseError: Error {
    func foo() {
        
    }
}

func romanNumeral(from: Int) throws -> String {
    let romanNumeralDict: [Int : String] =
        [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
    guard let numeral = romanNumeralDict[from] else {
        throw ParseError()
    }
    return numeral
}


let numbers = [5, 4, 3, 2, 1, 0]

func createTryMap2() -> some Publisher {
    let pub1 = numbers.publisher
    let pub2 = pub1.tryMap { try romanNumeral(from: $0) }
    return pub2
}

class Global {
    static var publisher: Any?
    static var cancel: Any?
}


createTryMap2().sink { it in
    switch it {
    case .finished:
        print("finished")
    case .failure(let error):
        print(error)
    }
} receiveValue: { it in
    print(it)
}


do {
    try _ = romanNumeral(from: 1)
} catch {
    print(error)
}

check("recover") {
    ["1", "2", "3", "swift", "4"]
        .publisher
        .flatMap { s in
            Just(s)
                .tryMap { s -> Int in
                    guard let r = Int(s) else {
                        throw MyError.myError
                    }
                    return r
                }
                .tryCatch {
                    _ in Just(-1)
                }
        }
}
