//
//  ContentView.swift
//  TestIconTint
//
//  Created by xipingping on 6/25/24.
//

import SwiftUI

struct UIImageViewWrapper: UIViewRepresentable {
  func makeUIView(context: Context) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ic_crop_close")?.withTintColor(.yellow)
    return imageView
  }

  func updateUIView(_ uiView: UIImageView, context: Context) {

  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      UIImageViewWrapper()
//      makeImage()
//        .imageScale(.large)
//        .background(Color.gray)
//        .foregroundStyle(.blue)

      Text("Hello, world!")
        .foregroundColor(.blue)
    }
    .padding()
  }

  /// return a tint blue image
  private var uiImage: UIImage? {
//    UIImage(named: "ic_crop_close")?.withRenderingMode(.alwaysTemplate).withTintColor(.blue)
    UIImage(named: "ic_crop_close")?.withTintColor(.blue, renderingMode: .alwaysTemplate)
//      ?.withTintColor(.yellow, renderingMode: .alwaysTemplate)
  }

  private func makeImage() -> Image {
    if let image = self.uiImage {
      return Image(uiImage: image)
    } else {
      return Image(systemName: "clock")
    }
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.light)
}
