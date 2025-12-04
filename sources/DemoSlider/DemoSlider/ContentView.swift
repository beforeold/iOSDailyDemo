import SwiftUI

struct ContentView: View {
  @State private var sliderValue: Double = 0.5

  var body: some View {
    VStack(spacing: 24) {
      VStack {
        Text("Slider value")
          .font(.headline)
        Text(String(format: "%.2f", sliderValue))
          .font(.largeTitle.monospacedDigit())
      }

      UIKitSlider(value: $sliderValue)
        .frame(height: 44)
        .padding(.horizontal, 24)

      HStack {
        Text("0")

        Text("iOS \(UIDevice.current.systemVersion)")

        Text("1")
      }
      .font(.subheadline.monospacedDigit())
      .padding(.horizontal, 24)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}

class MySlider: UISlider {
  override func layoutSubviews() {
    super.layoutSubviews()

    logSubviews(of: self)
  }

  private func logSubviews(of view: UIView, indent: String = "") {
    let description = "\(indent)\(type(of: view)) frame: \(view.frame)"
    print(description)
    for subview in view.subviews {
      logSubviews(of: subview, indent: indent + "  ")
    }
  }
}

struct UIKitSlider: UIViewRepresentable {
  @Binding var value: Double

  func makeCoordinator() -> Coordinator {
    Coordinator(value: $value)
  }

  func makeUIView(context: Context) -> UISlider {
    let slider = MySlider(frame: .zero)
    slider.minimumValue = 0
    slider.maximumValue = 1
    slider.value = Float(value)

//    let minImage = Self.trackImage(color: .systemGray, height: 1)
//    slider.setMinimumTrackImage(minImage, for: .normal)
//
//    let maxImage = Self.trackImage(color: .yellow, height: 1)
//    slider.setMaximumTrackImage(maxImage, for: .normal)

    slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)

    slider.setThumbImage(
      UIImage(
        systemName: "circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 10)
      ),
      for: .normal
    )
    slider.setThumbImage(nil, for: .normal)
    slider.tintColor = .purple

    if #available(iOS 26.0, *) {
      slider.sliderStyle = .thumbless
      slider.transform = .init(scaleX: 1, y: 0.5)
    }

    return slider
  }

  func updateUIView(_ uiView: UISlider, context: Context) {
    if Float(value) != uiView.value {
      uiView.value = Float(value)
    }
  }

  class Coordinator: NSObject {
    @Binding var value: Double

    init(value: Binding<Double>) {
      _value = value
    }

    @objc func valueChanged(_ sender: UISlider) {
      value = Double(sender.value)
    }
  }

  private static func trackImage(color: UIColor, height: CGFloat) -> UIImage? {
    let size = CGSize(width: 1, height: height)
    let renderer = UIGraphicsImageRenderer(size: size)
    let image = renderer.image { context in
      color.setFill()
      context.fill(CGRect(origin: .zero, size: size))
    }
    return image.resizableImage(withCapInsets: .zero, resizingMode: .stretch).withRenderingMode(.alwaysOriginal)
  }
}
#Preview {
  ContentView()
}
