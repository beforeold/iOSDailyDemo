import SwiftUI

struct ContentView: View {
  @Namespace private var namespace
  @Namespace private var shape

  @State private var isFlipped = false

  var body: some View {
    VStack {
      if isFlipped {
        Rectangle()
          .matchedGeometryEffect(id: shape, in: namespace)
          .frame(width: 100, height: 100)
          .foregroundColor(.blue)
      } else {
        Circle()
          .matchedGeometryEffect(id: shape, in: namespace)
          .frame(maxWidth: .infinity, maxHeight: 400)
          .foregroundColor(.red)
      }

      Button("Toggle") {
        withAnimation {
          isFlipped.toggle()
        }
      }
    }
    .padding()
  }
}

struct TestScrollViewReader: View {
  @Namespace var topID
  @Namespace var bottomID

  var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        Button("Scroll to Bottom") {
          withAnimation {
            proxy.scrollTo(bottomID)
          }
        }
        .id(topID)


        VStack(spacing: 0) {
          ForEach(0..<100) { i in
            color(fraction: Double(i) / 100)
              .frame(height: 32)
          }
        }


        Button("Top") {
          withAnimation {
            proxy.scrollTo(topID)
          }
        }
        .id(bottomID)
      }
    }
  }


  func color(fraction: Double) -> Color {
    Color(red: fraction, green: 1 - fraction, blue: 0.5)
  }
}

#Preview {
  ContentView()
}

#Preview {
  TestScrollViewReader()
}
