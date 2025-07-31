import SwiftUI

public struct Line: View {
  public var width: CGFloat?
  public var height: CGFloat?
  public var color: Color

  public init(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    color: Color = .blue
  ) {
    self.width = width
    self.height = height
    self.color = color
  }

  public var body: some View {
    Rectangle()
      .fill(color)
      .frame(
        maxWidth: width ?? .infinity,
        maxHeight: height ?? .infinity
      )
  }
}
