import UIKit

final class AlertContentViewController: UIViewController {
    private let stack = UIStackView()
    private let switchRow = UIStackView()
    private let switchLabel = UILabel()
    private let toggle = UISwitch()
    private let detailLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        switchLabel.text = "Show details"
        switchLabel.font = .preferredFont(forTextStyle: .subheadline)
        switchLabel.adjustsFontForContentSizeCategory = true
        switchLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        toggle.setContentHuggingPriority(.required, for: .horizontal)

        switchRow.axis = .horizontal
        switchRow.alignment = .center
        switchRow.spacing = 8
        switchRow.addArrangedSubview(switchLabel)
        switchRow.addArrangedSubview(toggle)

        detailLabel.text = "Extra info: tucked-away copy revealed by the switch."
        detailLabel.font = .preferredFont(forTextStyle: .footnote)
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.isHidden = true

        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(switchRow)
        stack.addArrangedSubview(detailLabel)

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSize()
    }

    private func updatePreferredContentSize() {
        let targetWidth = view.bounds.width > 0 ? view.bounds.width : 270
        let fittingSize = stack.systemLayoutSizeFitting(
            CGSize(width: targetWidth - 32, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        let newSize = CGSize(width: targetWidth, height: fittingSize.height + 8)
        if preferredContentSize != newSize {
            preferredContentSize = newSize
        }
    }

    @objc private func toggleChanged() {
        detailLabel.isHidden = !toggle.isOn
        view.layoutIfNeeded()
        updatePreferredContentSize()
    }
}
