import MapKit
import SwiftUI
import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let mapView = UIView(frame: UIScreen.main.bounds)// MKMapView()
    mapView.backgroundColor = .red
    mapView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(mapView)

    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    let containerEffect = UIGlassContainerEffect()
    containerEffect.spacing = 0

    let glassContainer = UIVisualEffectView()
    glassContainer.effect = containerEffect
    glassContainer.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(glassContainer)

    NSLayoutConstraint.activate([
      glassContainer.topAnchor.constraint(equalTo: view.topAnchor),
      glassContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      glassContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      glassContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    let glassEffect = UIGlassEffect(style: .regular)
    glassEffect.isInteractive = true

    let leadingGlassView = UIVisualEffectView()
    leadingGlassView.effect = glassEffect
    leadingGlassView.cornerConfiguration = .capsule()
    leadingGlassView.translatesAutoresizingMaskIntoConstraints = false

    glassContainer.contentView.addSubview(leadingGlassView)

    NSLayoutConstraint.activate([
      leadingGlassView.trailingAnchor.constraint(equalTo: glassContainer.centerXAnchor, constant: -5),
      leadingGlassView.centerYAnchor.constraint(equalTo: glassContainer.centerYAnchor),
    ])

    let leadingButton = UIButton()
    leadingButton.configuration = .plain()
    leadingButton.configuration?.buttonSize = .large
    leadingButton.configuration?.image = UIImage(systemName: "ellipsis")
    leadingButton.translatesAutoresizingMaskIntoConstraints = false

    leadingGlassView.contentView.addSubview(leadingButton)

    NSLayoutConstraint.activate([
      leadingButton.topAnchor.constraint(equalTo: leadingGlassView.topAnchor),
      leadingButton.leadingAnchor.constraint(equalTo: leadingGlassView.leadingAnchor),
      leadingButton.trailingAnchor.constraint(equalTo: leadingGlassView.trailingAnchor),
      leadingButton.bottomAnchor.constraint(equalTo: leadingGlassView.bottomAnchor),
    ])

    let trailingGlassView = UIVisualEffectView()
    trailingGlassView.effect = glassEffect
    trailingGlassView.cornerConfiguration = .capsule()
    trailingGlassView.translatesAutoresizingMaskIntoConstraints = false

    glassContainer.contentView.addSubview(trailingGlassView)

    NSLayoutConstraint.activate([
      trailingGlassView.leadingAnchor.constraint(equalTo: glassContainer.centerXAnchor, constant: 5),
      trailingGlassView.centerYAnchor.constraint(equalTo: glassContainer.centerYAnchor),
    ])

    let trailingButton = UIButton()
    trailingButton.configuration = .plain()
    trailingButton.configuration?.buttonSize = .large
    trailingButton.configuration?.image = UIImage(systemName: "ellipsis")
    trailingButton.translatesAutoresizingMaskIntoConstraints = false

    trailingGlassView.contentView.addSubview(trailingButton)

    NSLayoutConstraint.activate([
      trailingButton.topAnchor.constraint(equalTo: trailingGlassView.topAnchor),
      trailingButton.leadingAnchor.constraint(equalTo: trailingGlassView.leadingAnchor),
      trailingButton.trailingAnchor.constraint(equalTo: trailingGlassView.trailingAnchor),
      trailingButton.bottomAnchor.constraint(equalTo: trailingGlassView.bottomAnchor),
    ])
  }
}

#Preview {
  ViewController()
}
