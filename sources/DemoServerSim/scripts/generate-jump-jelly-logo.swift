import AppKit
import Foundation

private let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
private let assetRoot = root.appendingPathComponent("DemoServerSim/Assets.xcassets")
private let appIconRoot = assetRoot.appendingPathComponent("AppIcon.appiconset")
private let imageSetRoot = assetRoot.appendingPathComponent("JumpJellyLogo.imageset")

private func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> NSColor {
  NSColor(red: red, green: green, blue: blue, alpha: alpha)
}

private func fillRounded(_ rect: CGRect, radius: CGFloat, color: NSColor) {
  color.setFill()
  NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

private func fillEllipse(_ rect: CGRect, color: NSColor) {
  color.setFill()
  NSBezierPath(ovalIn: rect).fill()
}

private func drawLogo(size: CGFloat) -> NSImage {
  let image = NSImage(size: CGSize(width: size, height: size))
  image.lockFocus()

  guard let context = NSGraphicsContext.current?.cgContext else {
    image.unlockFocus()
    return image
  }

  context.scaleBy(x: size / 1024, y: size / 1024)
  color(0.98, 0.94, 1.0).setFill()
  context.fill(CGRect(x: 0, y: 0, width: 1024, height: 1024))

  fillRounded(CGRect(x: 210, y: 230, width: 604, height: 178), radius: 89, color: color(0.54, 0.3, 0.64, 0.18))
  fillRounded(CGRect(x: 190, y: 286, width: 644, height: 196), radius: 98, color: color(1.0, 0.47, 0.62))
  fillRounded(CGRect(x: 242, y: 409, width: 540, height: 44), radius: 22, color: color(1, 1, 1, 0.42))

  fillEllipse(CGRect(x: 282, y: 334, width: 42, height: 42), color: color(1, 1, 1, 0.36))
  fillEllipse(CGRect(x: 612, y: 330, width: 34, height: 34), color: color(1, 1, 1, 0.3))
  fillEllipse(CGRect(x: 724, y: 386, width: 24, height: 24), color: color(1, 1, 1, 0.36))

  fillRounded(CGRect(x: 336, y: 474, width: 352, height: 326), radius: 96, color: color(0.3, 0.62, 0.68, 0.18))
  fillRounded(CGRect(x: 342, y: 516, width: 340, height: 340), radius: 104, color: color(0.48, 0.94, 0.9))
  fillEllipse(CGRect(x: 412, y: 762, width: 144, height: 58), color: color(1, 1, 1, 0.62))

  fillEllipse(CGRect(x: 444, y: 646, width: 42, height: 42), color: color(0.23, 0.13, 0.24))
  fillEllipse(CGRect(x: 538, y: 646, width: 42, height: 42), color: color(0.23, 0.13, 0.24))
  fillEllipse(CGRect(x: 396, y: 610, width: 42, height: 30), color: color(1.0, 0.44, 0.61, 0.72))
  fillEllipse(CGRect(x: 586, y: 610, width: 42, height: 30), color: color(1.0, 0.44, 0.61, 0.72))

  context.setStrokeColor(color(0.23, 0.13, 0.24).cgColor)
  context.setLineWidth(18)
  context.setLineCap(.round)
  context.move(to: CGPoint(x: 478, y: 615))
  context.addQuadCurve(to: CGPoint(x: 546, y: 615), control: CGPoint(x: 512, y: 580))
  context.strokePath()

  image.unlockFocus()
  return image
}

private func writePNG(_ image: NSImage, to url: URL) throws {
  guard
    let tiff = image.tiffRepresentation,
    let bitmap = NSBitmapImageRep(data: tiff),
    let png = bitmap.representation(using: .png, properties: [:])
  else {
    throw NSError(domain: "LogoGenerator", code: 1)
  }

  try png.write(to: url)
}

private let appIconSizes: [(String, CGFloat)] = [
  ("Icon-20.png", 20),
  ("Icon-20@2x.png", 40),
  ("Icon-20@3x.png", 60),
  ("Icon-29.png", 29),
  ("Icon-29@2x.png", 58),
  ("Icon-29@3x.png", 87),
  ("Icon-40.png", 40),
  ("Icon-40@2x.png", 80),
  ("Icon-40@3x.png", 120),
  ("Icon-60@2x.png", 120),
  ("Icon-60@3x.png", 180),
  ("Icon-76.png", 76),
  ("Icon-76@2x.png", 152),
  ("Icon-83.5@2x.png", 167),
  ("Icon-1024.png", 1024)
]

private let logoSizes: [(String, CGFloat)] = [
  ("JumpJellyLogo.png", 128),
  ("JumpJellyLogo@2x.png", 256),
  ("JumpJellyLogo@3x.png", 384)
]

try FileManager.default.createDirectory(at: appIconRoot, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: imageSetRoot, withIntermediateDirectories: true)

for icon in appIconSizes {
  try writePNG(drawLogo(size: icon.1), to: appIconRoot.appendingPathComponent(icon.0))
}

for logo in logoSizes {
  try writePNG(drawLogo(size: logo.1), to: imageSetRoot.appendingPathComponent(logo.0))
}
