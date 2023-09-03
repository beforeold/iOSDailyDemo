import Combine

check("Empty") {
    Empty<Int, SampleError>()
}

check("Just") {
    Just(1)
}

check("Fail") {
    Fail(
        outputType: Int.self,
        failure: SampleError.sampleError)
}
