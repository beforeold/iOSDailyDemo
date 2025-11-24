import UIKit

class ViewController: UIViewController {

  private let slider: UISlider = {
    let slider = UISlider()
    slider.setThumbImage(
      UIImage(
        systemName: "circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 10)
      ),
      for: .normal
    )
    slider.minimumTrackTintColor = .white
    slider.maximumTrackTintColor = .white.withAlphaComponent(0.2)
    slider.minimumValue = 0
    slider.maximumValue = 1
    slider.tintColor = .blue
    slider.value = 0.5
    return slider
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    slider.addTarget(self, action: #selector(sliderTouchBegan(_:)), for: .touchDown)
    slider.addTarget(self, action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

    view.addSubview(slider)

    NSLayoutConstraint.activate([
      slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      slider.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  @objc
  private func sliderValueChanged(_ sender: UISlider) {
    print("Slider value changed: \(sender.value)")
  }

  @objc
  private func sliderTouchBegan(_ sender: UISlider) {
    print("Slider touch began at value: \(sender.value)")
  }

  @objc
  private func sliderTouchEnded(_ sender: UISlider) {
    print("Slider touch ended at value: \(sender.value)")
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewControllerPreview: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> ViewController {
    ViewController()
  }

  func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

struct ViewControllerPreview_Previews: PreviewProvider {
  static var previews: some View {
    ViewControllerPreview()
      .edgesIgnoringSafeArea(.all)
      .previewDisplayName("Demo Slider Events")
      .colorScheme(.dark)
  }
}
#endif
