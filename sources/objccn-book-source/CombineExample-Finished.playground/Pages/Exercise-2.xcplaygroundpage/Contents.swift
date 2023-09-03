import Combine
import Foundation

let searchText = PassthroughSubject<String, Never>()

var temp = check("Debounce") {
    searchText
        .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
}

delay(0) { searchText.send("S") }
delay(0.1) { searchText.send("Sw") }
delay(0.2) { searchText.send("Swi") }
delay(1.3) { searchText.send("Swif") }
delay(1.4) { searchText.send("Swift") }
