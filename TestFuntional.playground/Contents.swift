import Cocoa

var str = "Hello, playground"


typealias Func = (Int) -> Int


func add(_ v1: Int) -> Func {
    return { $0 + v1 }
}


func minus(_ v1: Int) -> Func {
    return { $0 - v1 }
}

func composite<A, B, C>(_ f1: @escaping (A) -> B,
                        _ f2: @escaping (B) -> C)
    -> (A) -> (C)
{
    { f2(f1($0)) }
}

let addMinus = composite(add(5), minus(10))
let ret = addMinus(10)

infix operator >>>: AdditionPrecedence
func >>><A, B, C>(_ f1: @escaping (A) -> B,
                  _ f2: @escaping (B) -> C)
    -> (A) -> (C)
{
    { f2(f1($0)) }
}

let addMinus2 = add(5) >>> minus(10)
addMinus2(10)

let ret2 = (add(5) >>> minus(10))(10)


func add3(_ v1: Int, _ v2: Int, _ v3: Int) -> Int {
    return v1 - v2 - v3
}

let add345 = add3(3, 4, 5)

func add4(_ v1: Int) -> (Int) -> ((Int) -> Int) {
    return
        { v2 in
            { v3 in
                add3(v1, v2, v3)
        }
    }
}

let sss: String? = nil
sss.map{ $0 }

add4(3)(4)(5)

static func play<A, B>(_ fn: ((A) -> B)?,
                      _ value: A?) -> B? {
    guard let v = value else { return nil }
    guard let f = fn else { return nil }
    return f(v)
}

infix operator <*>: AdditionPrecedence

extension Optional {
    
}

func map(_ value: Int) -> Double {
    return Double(value)
}

play(map, 3)
