import Combine
import Foundation

let subject_example1 = PassthroughSubject<Int, Never>()
let subject_example2 = PassthroughSubject<Int, Never>()

check("Subject Order") {
    subject_example1.merge(with: subject_example2)
}

subject_example1.send(20)
subject_example2.send(1)
subject_example1.send(40)
subject_example1.send(60)
subject_example2.send(1)
subject_example1.send(80)
subject_example1.send(100)
subject_example1.send(completion: .finished)
subject_example2.send(completion: .finished)

print("\nzip on Sequence")
for tuple in zip([1, 2, 3, 4, 5], ["A", "B", "C", "D"]) {
    print(tuple)
}

let subject1 = PassthroughSubject<Int, Never>()
let subject2 = PassthroughSubject<String, Never>()

check("Zip") {
    subject1.zip(subject2)
}

subject1.send(1)
subject2.send("A")
subject1.send(2)
subject2.send("B")
subject2.send("C")
subject2.send("D")
subject1.send(3)
subject1.send(4)
subject1.send(5)

let subject3 = PassthroughSubject<Int, Never>()
let subject4 = PassthroughSubject<String, Never>()

check("Combine Latest") {
    subject3.combineLatest(subject4)
}

subject3.send(1)
subject4.send("A")
subject3.send(2)
subject4.send("B")
subject4.send("C")
subject4.send("D")
subject3.send(3)
subject3.send(4)
subject3.send(5)
