//
//  ContentView.swift
//  TestNegativePadding
//
//  Created by xipingping on 8/12/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        Image("Pic")
          .resizable()
          .aspectRatio(contentMode: .fill)
      }
      .scrollIndicators(.hidden)
      .frame(width: 300, height: 300)

      TransparentBlurView(removeAllFilters: true)
//        .background(Color.blue)
        .blur(radius: 30, opaque: false)
//        .padding([.horizontal], -30)
        .background(Color.blue)
        .frame(width: 300, height: 100)
        .zIndex(1000)
        .clipped()
    }
    .frame(width: 300, height: 300)
    //    .background(Color.red)
    .padding(50)
    //    .background(Color.green)
  }
}

#Preview {
  ContentView()
//    .preferredColorScheme(.dark)
}


struct TransparentBlurView: UIViewRepresentable {
  var removeAllFilters: Bool? = false

  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))

    return view
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    DispatchQueue.main.async {
      //      print(uiView.layer.sublayers?.count)
      //      print(uiView.layer.sublayers?[0].filters)
      guard let removeAllFilters else { return }

      if let backdropLayer = uiView.layer.sublayers?.first {
        if removeAllFilters {
          backdropLayer.filters = []
        } else {
          // Removing All Expect Blur Filter
          backdropLayer.filters?.removeAll(where: { filter in
            String(describing: filter) != "gaussianBlur"
          })
        }
      }
    }
  }
}
