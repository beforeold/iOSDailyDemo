import Combine

check("FlatMap Operator") {
    [[1, 2, 3], [4, 5, 6]]
        .publisher
        .flatMap { $0.publisher }
}

let p1 = Publishers.FlatMap(
    upstream: [[1, 2, 3], [4, 5, 6]].publisher,
    maxPublishers: .unlimited)
{
    $0.publisher
}

check("FlatMap Type") {
    p1
}

check("Map Operator") {
    p1.map { $0 * 2 }
}

let p2 = Publishers.Map(upstream: p1) { $0 * 2 }
check("Map Type") {
    p2
}

// p2: Publishers.Map<
//         Publishers.FlatMap<
//             Publishers.Sequence<[Int], Never>,
//             Publishers.Sequence<[[Int]], Never>
//         >,
//         Int
//      >

let p3 = p2.eraseToAnyPublisher()
// p3: AnyPublisher<Int, Never>
