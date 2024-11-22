import Foundation
import os

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = "com.apple.bundle"

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}

//let logger = OSLog(subsystem: "com.apple.id", category: "Person")
//logger.info("Hello, World!")

let logger = Logger(subsystem: "com.apple.id", category: "Person")
logger.info("Hello, World!")

let userName = "br"
logger.info("User \(userName, privacy: .private) logged in")
Logger.viewCycle.notice("Notice example")
Logger.viewCycle.info("Info example")
Logger.viewCycle.debug("Debug example")
Logger.viewCycle.trace("Notice example")
Logger.viewCycle.warning("Warning example")
Logger.viewCycle.error("Error example")
Logger.viewCycle.fault("Fault example")
Logger.viewCycle.critical("Critical example")
