import Combine

check("Filter") {
    [1,2,3,4,5].publisher.filter { $0 % 2 == 0 }
}

check("Contains") {
    [1,2,3,4,5].publisher
        .print("[Original]")
        .contains(3)
}
