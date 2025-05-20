import SwiftUI

// 自定义垂直对齐指南
extension HorizontalAlignment {
  private enum CustomAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      return context[HorizontalAlignment.center]  // 默认与顶部对齐（左边文字的对齐方式）
    }
  }
  static let customAlignment = HorizontalAlignment(CustomAlignment.self)
}

struct ContentView: View {
  var body: some View {
    VStack(alignment: .customAlignment) {
      // 每一行用 HStack 包裹，对齐方式设为自定义指南
      HStack(alignment: .center) {
        // 左边文字部分（顶部对齐）
        VStack(alignment: .leading) {
          Text("row1, abc")
        }
        Spacer()  // 中间留白

        // 右边图标（垂直居中对齐）
        Image(systemName: "circle.fill")
          .alignmentGuide(.customAlignment) { $0[.leading] }  // 关键点：对齐到中心

        Text("1")
      }

      // 其他行同理
      HStack(alignment: .center) {
        VStack(alignment: .leading) {
          Text("row2 q342424")
        }

        Spacer()

        Image(systemName: "square.fill")
          .alignmentGuide(.customAlignment) { $0[.leading] }

        Text("2")
      }

      HStack(alignment: .center) {
        VStack(alignment: .leading) {
          Text("row3 24324")
        }

        Spacer()

        Image(systemName: "triangle.fill")
          .alignmentGuide(.customAlignment) { $0[VerticalAlignment.center] }

        Text("200")
      }
    }
    .padding()
  }
}

extension HorizontalAlignment {
  private enum IconAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      return context[HorizontalAlignment.center]
    }
  }
  static let iconAlignment = HorizontalAlignment(IconAlignment.self)
}

struct Stack: View {
  var body: some View {
    VStack(alignment: .iconAlignment, spacing: 12) {
      HStack {
        Text("Row 1 label")
          .frame(width: 200, alignment: .leading)
//        Spacer()
        HStack(spacing: 4) {
          Image(systemName: "star")

          Text("1")
        }
        .alignmentGuide(.iconAlignment) { d in d[HorizontalAlignment.leading] }
      }

      HStack {
        Text("Another label")
          .frame(width: 200, alignment: .leading)
//        Spacer()
        HStack(spacing: 4) {
          Image(systemName: "heart")
          Text("2222")
        }
        .alignmentGuide(.iconAlignment) { d in d[HorizontalAlignment.leading] }
      }

      HStack {
        Text("Final label")
          .frame(width: 200, alignment: .leading)
//        Spacer()
        HStack(spacing: 4) {
          Image(systemName: "bolt")
          Text("33333333")
        }
        .alignmentGuide(.iconAlignment) { d in d[HorizontalAlignment.leading] }
      }
    }
  }
}

#Preview {
  Stack()
    .padding()
}
