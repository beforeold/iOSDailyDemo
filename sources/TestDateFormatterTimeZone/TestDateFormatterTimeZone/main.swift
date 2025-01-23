import Foundation


let date = Date() // Current date and time

// Create a DateFormatter
let dateFormatter = DateFormatter()
dateFormatter.locale = .init(identifier: "zh_CN")
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Set your desired format
dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai") // Beijing time zone
dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .medium

// Format the date
let beijingTime = dateFormatter.string(from: date)
print("Beijing Time: \(beijingTime)")
