import CoreGraphics
import Foundation

var frameMap: [String: CGRect] = [:]

func update(_ frame: CGRect, forTaskId taskId: String) {
  var adjustedFrame = frame
  let screenWidth: CGFloat = 375

  if adjustedFrame.origin.x < 0 || adjustedFrame.origin.x > screenWidth {
    let modX = adjustedFrame.origin.x.truncatingRemainder(dividingBy: screenWidth)
    adjustedFrame.origin.x = modX >= 0 ? modX : modX + screenWidth
  }

  frameMap[taskId] = adjustedFrame
}

update(.init(x: -800, y: 0, width: 300, height: 300), forTaskId: "0")
update(.init(x: -200, y: 0, width: 300, height: 300), forTaskId: "1")
update(.init(x: 200, y: 0, width: 300, height: 300), forTaskId: "2")
update(.init(x: 400, y: 0, width: 300, height: 300), forTaskId: "3")
update(.init(x: 800, y: 0, width: 300, height: 300), forTaskId: "4")


frameMap.forEach {
  print($0)
}
