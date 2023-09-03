import Combine
import Foundation

let timer = Timer.publish(every: 1, on: .main, in: .default)
let temp = check("Timer Connected") {
    timer
}
timer.connect()

