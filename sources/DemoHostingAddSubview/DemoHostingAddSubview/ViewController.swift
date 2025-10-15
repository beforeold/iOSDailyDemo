import UIKit
import SwiftUI

struct ExampleSwiftUIView: View {
  var body: some View {
    VStack(spacing: 12) {
      Text("SwiftUI says hi!")
        .font(.title2)
        .fontWeight(.semibold)
      Text("This view is embedded inside a UIKit view controller using UIHostingController.")
        .font(.body)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
      Button("Tap Me") {
        // Intentionally simple action placeholder
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
  }
}

class ViewController: UIViewController {

  private lazy var presentButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Show SwiftUI View", for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.addTarget(self, action: #selector(presentExampleView), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    view.addSubview(presentButton)

    NSLayoutConstraint.activate([
      presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  @objc
  private func presentExampleView() {
    // Present the SwiftUI view using a hosting controller to show interop behavior.
    let hostingController = UIHostingController(rootView: ExampleSwiftUIView())
    hostingController.modalPresentationStyle = .automatic
    present(hostingController, animated: true) {
      // Add an extra UIKit label on top of the SwiftUI view once it is visible.
      guard let superView = hostingController.view.superview else { return }
      let overlayLabel = UILabel()
      overlayLabel.text = "UIKit overlay label"
      overlayLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
      overlayLabel.textColor = .white
      overlayLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
      overlayLabel.layer.cornerRadius = 8
      overlayLabel.clipsToBounds = true
      overlayLabel.textAlignment = .center
      overlayLabel.translatesAutoresizingMaskIntoConstraints = false

      superView.addSubview(overlayLabel)
      NSLayoutConstraint.activate([
        overlayLabel.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
        overlayLabel.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: 16),
        overlayLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),
        overlayLabel.heightAnchor.constraint(equalToConstant: 32)
      ])
    }
  }

}
