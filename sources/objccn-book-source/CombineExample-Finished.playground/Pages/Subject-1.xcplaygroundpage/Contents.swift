import Combine

let s1 = check("Subject") {
    () -> PassthroughSubject<Int, Never> in
    let subject = PassthroughSubject<Int, Never>()
    delay(1) {
        subject.send(1)
        delay(1) {
            subject.send(2)
            delay(1) {
                subject.send(completion: .finished)
            }
        }
    }
    return subject
}
