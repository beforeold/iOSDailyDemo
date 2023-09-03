import Combine
import Foundation

class Wrapper {
    @Published var text: String = "hoho"
}

var wrapper = Wrapper()
check("Published") {
    wrapper.$text
}

wrapper.text = "123"
wrapper.text = "abc"
