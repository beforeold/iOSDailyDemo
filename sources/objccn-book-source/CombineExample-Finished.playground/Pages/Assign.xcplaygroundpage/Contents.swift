import Combine
import SwiftUI

class Clock {
    var timeString: String = "--:--:--" {
        didSet { print("\(timeString)") }
    }
}

let clock = Clock()

let formatter = DateFormatter()
formatter.timeStyle = .medium

let timer = Timer.publish(every: 1, on: .main, in: .default)
var token = timer
    .map { formatter.string(from: $0) }
    .assign(to: \.timeString, on: clock)

timer.connect()
