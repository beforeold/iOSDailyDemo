import SwiftUI

struct BlurView: UIViewRepresentable {
  var style: UIBlurEffect.Style

  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
    return view
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}

struct GradientMask: View {
  var body: some View {
    LinearGradient(
      gradient: Gradient(stops: [
        .init(color: .clear, location: 0.0),
        .init(color: .black, location: 1.0)
      ]),
      startPoint: .top,
      endPoint: .bottom
    )
  }
}

struct TransparentGradientMask: View {
  var body: some View {
    LinearGradient(
      gradient: Gradient(colors: [.clear, .black]),
      startPoint: .top,
      endPoint: .bottom
    )
    .edgesIgnoringSafeArea(.all)
  }
}

struct GradientBlurOverlay: View {
  var body: some View {
//    LinearGradient(
//      gradient: Gradient(colors: [.clear, .black.opacity(0.6)]), // Adjust the opacity as needed
//      startPoint: .top,
//      endPoint: .bottom
//    )
//    .edgesIgnoringSafeArea(.all)
    Color.blue
  }
}

struct GradientBlurView: View {
  var body: some View {
    ZStack {
      // Background content
      Color.red
        .edgesIgnoringSafeArea(.all)

      // Blur effect
      BlurView(style: .light)
        .edgesIgnoringSafeArea(.all)

      // Gradient overlay
      GradientBlurOverlay()
        .blendMode(.overlay)
    }
  }
}

//struct GradientBlurView: View {
//    var body: some View {
//        ZStack {
//            // Your background content
//            Color.blue
//                .edgesIgnoringSafeArea(.all)
//
//            // The blur effect with the gradient mask
//            BlurView(style: .light)
//                .edgesIgnoringSafeArea(.all)
//                .mask(
//                    TransparentGradientMask()
//                )
//        }
//    }
//}

//struct GradientBlurView: View {
//  var body: some View {
//    ZStack {
//      // Your background content
//      Color.blue
//        .edgesIgnoringSafeArea(.all)
//
//      // The blur effect
//      BlurView(style: .light)
//        .edgesIgnoringSafeArea(.all)
//        .mask(
//          GradientMask()
//        )
//    }
//  }
//}

struct ContentView: View {
  var body: some View {
    GradientBlurView()
      .frame(height: 200) // Adjust the frame as needed
  }
}

#Preview {
  ContentView()
}
