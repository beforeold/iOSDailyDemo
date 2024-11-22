import Foundation
import os

let logger = Logger(subsystem: "com.test.app", category: "home_page")

logger.log("ok")
logger.log(level: .error, "error")

print("Hello, World!")
