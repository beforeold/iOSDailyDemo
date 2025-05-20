import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

extension HorizontalAlignment {
  enum IconAlignemt: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[HorizontalAlignment.center]
    }
  }

  static let icon = HorizontalAlignment(IconAlignemt.self)
}

#Preview {
  HStack(alignment: .center) {
    Text("Hello, world!")
      .background(Color.blue)
      .font(.largeTitle)

//    Spacer()

    Text("ic 2222")
      .font(.largeTitle)
      .background(Color.red)
      .alignmentGuide(VerticalAlignment.center) { context in
        context[VerticalAlignment.bottom]
      }
  }
  .background(Color.gray.opacity(0.7))
  .padding()
}


#Preview {
  VStack(alignment: .icon) {
    HStack(alignment: .firstTextBaseline) {
      Text("Hello, world!")
      Spacer()
      Text("ic 1")
        .alignmentGuide(.icon) { context in
          context[.leading]
        }
    }

    HStack(alignment: .firstTextBaseline) {
      Text("Hello, world!")

      Spacer()
      Text("ic 2222")
        .alignmentGuide(.icon) { context in
          context[.leading]
        }
    }
  }
  .padding()
}
