import SwiftUI
import UIKit

@MainActor
final class UIKitDebugViewController: UIViewController {
    private let statusLabel = UILabel()
    private let eventCountLabel = UILabel()
    private let detailLabel = UILabel()

    private var eventCount = 5 {
        didSet {
            eventCountLabel.text = "\(eventCount)"
            detailLabel.text = "UIKit event stream updated \(eventCount) times."
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "UIKit Title Changed"

        let rootBackgroundView = UIView()
        rootBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        rootBackgroundView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.18)
        rootBackgroundView.layer.cornerRadius = 12
        view.addSubview(rootBackgroundView)

        let rootStack = UIStackView()
        rootStack.axis = .vertical
        rootStack.spacing = 20
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        rootStack.isLayoutMarginsRelativeArrangement = true
        rootStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        view.addSubview(rootStack)

        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.spacing = 8

        let eyebrowLabel = UILabel()
        eyebrowLabel.text = "UIKit Direct Controller"
        eyebrowLabel.font = .preferredFont(forTextStyle: .subheadline)
        eyebrowLabel.textColor = .tintColor
        eyebrowLabel.adjustsFontForContentSizeCategory = true

        let titleLabel = UILabel()
        titleLabel.text = "Direct UIKit preview reload check"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true

        let subtitleLabel = UILabel()
        subtitleLabel.text = "This UIViewController was changed after the preview host launched, then refreshed through package hot reload."
        subtitleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.adjustsFontForContentSizeCategory = true

        headerStack.addArrangedSubview(eyebrowLabel)
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(subtitleLabel)

        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 16
        cardStack.isLayoutMarginsRelativeArrangement = true
        cardStack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        cardStack.backgroundColor = .secondarySystemGroupedBackground
        cardStack.layer.cornerRadius = 12
        cardStack.layer.borderColor = UIColor.separator.withAlphaComponent(0.35).cgColor
        cardStack.layer.borderWidth = 1

        let cardHeaderStack = UIStackView()
        cardHeaderStack.axis = .horizontal
        cardHeaderStack.alignment = .center
        cardHeaderStack.spacing = 12

        let cardTitleLabel = UILabel()
        cardTitleLabel.text = "Reloaded Controller State"
        cardTitleLabel.font = .preferredFont(forTextStyle: .headline)
        cardTitleLabel.adjustsFontForContentSizeCategory = true

        statusLabel.text = "Ready"
        statusLabel.font = .preferredFont(forTextStyle: .caption1)
        statusLabel.textColor = .systemTeal
        statusLabel.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.12)
        statusLabel.layer.cornerRadius = 12
        statusLabel.layer.masksToBounds = true
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        cardHeaderStack.addArrangedSubview(cardTitleLabel)
        cardHeaderStack.addArrangedSubview(UIView())
        cardHeaderStack.addArrangedSubview(statusLabel)

        let metricStack = UIStackView()
        metricStack.axis = .horizontal
        metricStack.spacing = 12
        metricStack.distribution = .fillEqually

        metricStack.addArrangedSubview(makeMetricTile(title: "Events", valueLabel: eventCountLabel))
        metricStack.addArrangedSubview(makeStaticMetricTile(title: "Mode", value: "Preview"))

        detailLabel.text = "UIKit event stream updated \(eventCount) times."
        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0
        detailLabel.adjustsFontForContentSizeCategory = true

        let actionButton = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Record Reloaded Event"
        configuration.image = UIImage(systemName: "waveform")
        configuration.imagePadding = 8
        configuration.cornerStyle = .medium
        actionButton.configuration = configuration
        actionButton.addTarget(self, action: #selector(recordEvent), for: .touchUpInside)

        cardStack.addArrangedSubview(cardHeaderStack)
        cardStack.addArrangedSubview(metricStack)
        cardStack.addArrangedSubview(detailLabel)
        cardStack.addArrangedSubview(actionButton)

        rootStack.addArrangedSubview(headerStack)
        rootStack.addArrangedSubview(cardStack)

        NSLayoutConstraint.activate([
            rootStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rootStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rootStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            rootBackgroundView.leadingAnchor.constraint(equalTo: rootStack.leadingAnchor),
            rootBackgroundView.trailingAnchor.constraint(equalTo: rootStack.trailingAnchor),
            rootBackgroundView.topAnchor.constraint(equalTo: rootStack.topAnchor),
            rootBackgroundView.bottomAnchor.constraint(equalTo: rootStack.bottomAnchor),
            actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
        ])

        eventCountLabel.text = "\(eventCount)"
    }

    private func makeMetricTile(title: String, valueLabel: UILabel) -> UIView {
        valueLabel.font = .preferredFont(forTextStyle: .title2)
        valueLabel.textColor = .label
        valueLabel.adjustsFontForContentSizeCategory = true
        return makeMetricContainer(title: title, valueView: valueLabel)
    }

    private func makeStaticMetricTile(title: String, value: String) -> UIView {
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .preferredFont(forTextStyle: .title3)
        valueLabel.textColor = .label
        valueLabel.adjustsFontForContentSizeCategory = true
        return makeMetricContainer(title: title, valueView: valueLabel)
    }

    private func makeMetricContainer(title: String, valueView: UIView) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        stack.backgroundColor = .systemBackground
        stack.layer.cornerRadius = 10

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .secondaryLabel
        titleLabel.adjustsFontForContentSizeCategory = true

        stack.addArrangedSubview(valueView)
        stack.addArrangedSubview(titleLabel)
        return stack
    }

    @objc private func recordEvent() {
        eventCount += 1
        statusLabel.text = "Updated"
    }
}

@available(iOS 17.0, *)
#Preview("UIKit Controller") {
    UINavigationController(rootViewController: UIKitDebugViewController())
}
