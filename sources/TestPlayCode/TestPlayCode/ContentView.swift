import SwiftUI

struct ContentView: View {
  var body: some View {
    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1720949763536-b6ebae9f38b5?ixid=M3w4OTk0OHwwfDF8YWxsfDd8fHx8fHwxfHwxNzMwMzU3Mzg0fA&ixlib=rb-4.0.3")) { image in
      image.resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .clipped()
    } placeholder: {
      ProgressView()
    }
    .clipShape(.rect(cornerRadius: 16))
  }
}

#Preview {
  ContentView()
}

struct GalleryView: View {
  var body: some View {
    ScrollView(.horizontal, showsIndicators: true) {
      HStack(spacing:12) {
        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1720949763536-b6ebae9f38b5?ixid=M3w4OTk0OHwwfDF8YWxsfDd8fHx8fHwxfHwxNzMwMzU3Mzg0fA&ixlib=rb-4.0.3")) { image in
          image.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 362, maxWidth: 362, minHeight: 0, maxHeight: .infinity)
            .clipped()
        } placeholder: {
          ProgressView()
        }
        .clipShape(.rect(cornerRadius: 16))
        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1729067915069-fb84564ca0ec?ixid=M3w4OTk0OHwwfDF8YWxsfDl8fHx8fHwxfHwxNzMwMzU3Mzg0fA&ixlib=rb-4.0.3")) { image in
          image.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 362, maxWidth: 362, minHeight: 0, maxHeight: .infinity)
            .clipped()
        } placeholder: {
          ProgressView()
        }
        .clipShape(.rect(cornerRadius: 16))
        .projectionEffect(transformValue(translateZ: -362.609130859375, scaleX: 0, scaleY: 0))
        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1728467459756-211f3c738697?ixid=M3w4OTk0OHwwfDF8YWxsfDEwfHx8fHx8MXx8MTczMDM1NzM4NHw&ixlib=rb-4.0.3")) { image in
          image.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 362, maxWidth: 362, minHeight: 0, maxHeight: .infinity)
            .clipped()
        } placeholder: {
          ProgressView()
        }
        .clipShape(.rect(cornerRadius: 16))
        .projectionEffect(transformValue(translateZ: -725.21826171875, scaleX: 0, scaleY: 0))
      }
      .padding(16)
    }
    .frame(width: 394, height: 780, alignment: .leading)
    .clipped()
    .ignoresSafeArea()
  }
}

func transformValue(translateX: CGFloat = 0, translateY: CGFloat = 0, translateZ: CGFloat = 0, rotationX: CGFloat = 0, rotationY: CGFloat = 0, rotationZ: CGFloat = 0, perspective: CGFloat = 500, scaleX: CGFloat = 1, scaleY: CGFloat = 1) -> ProjectionTransform {
  func toRadians(_ value: CGFloat) -> CGFloat {
    return value * .pi / 180
  }
  var transform = CATransform3DIdentity
  transform.m34 = -1 / perspective
  transform = CATransform3DTranslate(transform, translateX, translateY, translateZ)
  transform = CATransform3DScale(transform, scaleX, scaleY, 1)
  transform = CATransform3DRotate(transform, toRadians(rotationX), 1, 0, 0)
  transform = CATransform3DRotate(transform, toRadians(rotationY), 0, 1, 0)
  transform = CATransform3DRotate(transform, toRadians(rotationZ), 0, 0, 1)
  return ProjectionTransform(transform)
}

#Preview {
  GalleryView()
}
