import Foundation
import SwiftUI


public struct GradientImageView : View {
  var image: Image
  var height: CGFloat
  var width: CGFloat
  var blurStyle : UIBlurEffect.Style = .dark

  public init(image: Image, height: CGFloat, width: CGFloat, blurStyle: UIBlurEffect.Style) {
    self.image = image
    self.height = height
    self.width = width
    self.blurStyle = blurStyle
  }

  public var body: some View {
    ZStack(alignment: .bottom){
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: width , height: height)
        .clipped()


      VStack{}
        .frame(width: width , height: height)
        .background(
          VisualEffectView(effect: UIBlurEffect(style: blurStyle))
            .preferredColorScheme(.dark)
        )

      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: width , height: height)
        .mask(
          LinearGradient(
            stops: [
              .init(color: .white, location: 0),
              .init(color: .white, location: 0.4),
              .init(color: .clear, location: 0.80)
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
    }
  }
}


struct VisualEffectView: UIViewRepresentable {
  var effect: UIVisualEffect?

  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    return UIVisualEffectView()
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
    uiView.effect = effect
  }
}

struct GradientBlur: View {
  var body: some View {
    GradientImageView(
      image: Image(uiImage: UIImage(named: "Pic")!),
      height: 300,
      width: 300,
      blurStyle: .systemUltraThinMaterial
    )
  }
}

#Preview {
  GradientBlur()
}
