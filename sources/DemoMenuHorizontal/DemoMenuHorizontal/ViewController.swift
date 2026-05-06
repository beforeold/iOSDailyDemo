import UIKit

final class ViewController: UIViewController {
    private let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground

        let titleLabel = UILabel()
        titleLabel.text = "Horizontal Menu Actions"
        titleLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(
            for: .systemFont(ofSize: 28, weight: .bold)
        )
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Compare two native UIMenu layouts with compact horizontal action groups."
        subtitleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        resultLabel.text = "Choose a menu action"
        resultLabel.font = .preferredFont(forTextStyle: .caption1)
        resultLabel.adjustsFontForContentSizeCategory = true
        resultLabel.textColor = .secondaryLabel
        resultLabel.numberOfLines = 0

        let headerStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8

        let threeAcrossCard = makeCard(
            title: "Three across",
            detail: "Six actions total. The first row uses three medium menu actions.",
            iconName: "rectangle.grid.3x2",
            button: makeMenuButton(
                title: "Open 3-action row",
                subtitle: "Medium horizontal group",
                menu: makeMenu(horizontalCount: 3, title: "Three Across")
            )
        )

        let fourAcrossCard = makeCard(
            title: "Four across",
            detail: "Six actions total. The first row uses four compact icon actions.",
            iconName: "square.grid.4x3.fill",
            button: makeMenuButton(
                title: "Open 4-action row",
                subtitle: "Small horizontal group",
                menu: makeMenu(horizontalCount: 4, title: "Four Across")
            )
        )

        let statusPill = makeStatusPill()

        let contentStack = UIStackView(arrangedSubviews: [
            headerStack,
            threeAcrossCard,
            fourAcrossCard,
            statusPill,
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.setCustomSpacing(24, after: headerStack)
        contentStack.setCustomSpacing(20, after: fourAcrossCard)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            contentStack.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
            contentStack.widthAnchor.constraint(lessThanOrEqualToConstant: 560),
        ])
    }

    private func makeMenuButton(title: String, subtitle: String, menu: UIMenu) -> UIButton {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = title
        configuration.subtitle = subtitle
        configuration.image = UIImage(systemName: "filemenu.and.cursorarrow")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        configuration.baseForegroundColor = .systemBlue
        configuration.baseBackgroundColor = .systemBlue
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 18,
            bottom: 14,
            trailing: 18
        )

        let button = UIButton(configuration: configuration)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = false
        return button
    }

    private func makeCard(
        title: String,
        detail: String,
        iconName: String,
        button: UIButton
    ) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .secondarySystemGroupedBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.cornerCurve = .continuous
        cardView.layer.borderWidth = 1 / UIScreen.main.scale
        cardView.layer.borderColor = UIColor.separator.withAlphaComponent(0.45).cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.07
        cardView.layer.shadowRadius = 14
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        let symbolView = UIImageView(image: UIImage(systemName: iconName))
        symbolView.tintColor = UIColor(red: 0.10, green: 0.65, blue: 0.64, alpha: 1)
        symbolView.contentMode = .scaleAspectFit
        symbolView.translatesAutoresizingMaskIntoConstraints = false

        let symbolContainer = UIView()
        symbolContainer.backgroundColor = UIColor(red: 0.10, green: 0.65, blue: 0.64, alpha: 0.12)
        symbolContainer.layer.cornerRadius = 10
        symbolContainer.layer.cornerCurve = .continuous
        symbolContainer.translatesAutoresizingMaskIntoConstraints = false
        symbolContainer.addSubview(symbolView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(
            for: .systemFont(ofSize: 19, weight: .semibold)
        )
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        let detailLabel = UILabel()
        detailLabel.text = detail
        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let headingStack = UIStackView(arrangedSubviews: [symbolContainer, textStack])
        headingStack.axis = .horizontal
        headingStack.alignment = .top
        headingStack.spacing = 12

        let cardStack = UIStackView(arrangedSubviews: [headingStack, button])
        cardStack.axis = .vertical
        cardStack.spacing = 18
        cardStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(cardStack)

        NSLayoutConstraint.activate([
            symbolContainer.widthAnchor.constraint(equalToConstant: 44),
            symbolContainer.heightAnchor.constraint(equalToConstant: 44),
            symbolView.centerXAnchor.constraint(equalTo: symbolContainer.centerXAnchor),
            symbolView.centerYAnchor.constraint(equalTo: symbolContainer.centerYAnchor),
            symbolView.widthAnchor.constraint(equalToConstant: 22),
            symbolView.heightAnchor.constraint(equalToConstant: 22),

            cardStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            cardStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            cardStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            cardStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
        ])

        return cardView
    }

    private func makeStatusPill() -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        iconView.tintColor = UIColor(red: 0.10, green: 0.65, blue: 0.64, alpha: 1)
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [iconView, resultLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let pillView = UIView()
        pillView.backgroundColor = .secondarySystemGroupedBackground
        pillView.layer.cornerRadius = 18
        pillView.layer.cornerCurve = .continuous
        pillView.layer.borderWidth = 1 / UIScreen.main.scale
        pillView.layer.borderColor = UIColor.separator.withAlphaComponent(0.4).cgColor
        pillView.translatesAutoresizingMaskIntoConstraints = false
        pillView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: pillView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: pillView.leadingAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: pillView.trailingAnchor, constant: -14),
            stackView.bottomAnchor.constraint(equalTo: pillView.bottomAnchor, constant: -10),
        ])

        return pillView
    }

    private func makeMenu(horizontalCount: Int, title: String) -> UIMenu {
        let actions = (1...6).map { index in
            UIAction(
                title: "Action \(index)",
                image: UIImage(systemName: symbolName(for: index))
            ) { [weak self] _ in
                self?.resultLabel.text = "\(title): Action \(index)"
            }
        }

        let horizontalActions = Array(actions.prefix(horizontalCount))
        let remainingActions = Array(actions.dropFirst(horizontalCount))

        let horizontalMenu = UIMenu(
            title: "",
            options: .displayInline,
            children: horizontalActions
        )
        horizontalMenu.preferredElementSize = horizontalCount == 3 ? .medium : .small

        return UIMenu(
            title: "",
            children: [horizontalMenu] + remainingActions
        )
    }

    private func symbolName(for index: Int) -> String {
        switch index {
        case 1:
            return "star"
        case 2:
            return "heart"
        case 3:
            return "bookmark"
        case 4:
            return "paperplane"
        case 5:
            return "tray.and.arrow.down"
        default:
            return "ellipsis.circle"
        }
    }
}
