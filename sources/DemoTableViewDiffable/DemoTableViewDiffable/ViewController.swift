import UIKit

final class ViewController: UIViewController {
    private typealias DataSource = DemoDataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DemoSection, DemoRow>

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let headerView = SummaryHeaderView()
    private lazy var emptyStateView = makeEmptyStateView()

    private var dataSource: DataSource!
    private var rows = DemoRow.initialRows()
    private var statusText = "Ready"
    private var nextCustomRowNumber = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Diffable Table"
        navigationController?.navigationBar.prefersLargeTitles = true

        configureNavigation()
        configureTableView()
        configureDataSource()
        applySnapshot(animatingDifferences: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        sizeTableHeaderToFit()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        tableView.setEditing(editing, animated: animated)
        updateChrome(status: editing ? "Editing" : "Ready")
    }

    private func configureNavigation() {
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addRow)
        )
        addButton.accessibilityLabel = "Add row"

        let resetButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(resetRows)
        )
        resetButton.accessibilityLabel = "Reset rows"

        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItems = [addButton, resetButton]
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorInsetReference = .fromAutomaticInsets
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DemoCell.reuseIdentifier)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, row in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DemoCell.reuseIdentifier,
                for: indexPath
            )
            DemoCell.configure(cell, with: row)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        dataSource.deleteHandler = { [weak self] row in
            self?.delete(row)
        }
        dataSource.moveHandler = { [weak self] sourceIndexPath, destinationIndexPath in
            self?.moveRow(from: sourceIndexPath, to: destinationIndexPath)
        }
    }

    private func applySnapshot(
        animatingDifferences: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(rows, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        updateChrome()
    }

    private func updateChrome(status: String? = nil) {
        if let status {
            statusText = status
        }

        headerView.configure(rowCount: rows.count, status: statusText)
        sizeTableHeaderToFit()

        tableView.backgroundView = rows.isEmpty ? emptyStateView : nil
        navigationItem.leftBarButtonItem?.isEnabled = !rows.isEmpty

        if rows.isEmpty, isEditing {
            setEditing(false, animated: true)
        }
    }

    private func sizeTableHeaderToFit() {
        guard tableView.tableHeaderView === headerView else { return }

        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let height = headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        guard headerView.frame.width != targetSize.width || headerView.frame.height != height else {
            return
        }

        headerView.frame = CGRect(origin: .zero, size: CGSize(width: targetSize.width, height: height))
        tableView.tableHeaderView = headerView
    }

    @objc private func addRow() {
        let row = DemoRow.custom(number: nextCustomRowNumber)
        nextCustomRowNumber += 1
        rows.insert(row, at: 0)

        applySnapshot { [weak self] in
            guard let self, let indexPath = dataSource.indexPath(for: row) else { return }
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        updateChrome(status: "Added")
    }

    @objc private func resetRows() {
        rows = DemoRow.initialRows()
        nextCustomRowNumber = 1
        setEditing(false, animated: true)
        applySnapshot(animatingDifferences: true)
        updateChrome(status: "Reset")
    }

    private func delete(_ row: DemoRow) {
        rows.removeAll { $0.id == row.id }
        applySnapshot()
        updateChrome(status: "Deleted")
    }

    private func moveRow(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath,
              rows.indices.contains(sourceIndexPath.row)
        else {
            updateChrome(status: "Editing")
            return
        }

        let row = rows.remove(at: sourceIndexPath.row)
        let destinationRow = min(destinationIndexPath.row, rows.count)
        rows.insert(row, at: destinationRow)

        applySnapshot(animatingDifferences: false)
        updateChrome(status: "Moved")
    }

    private func makeEmptyStateView() -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = "No Rows"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontForContentSizeCategory = true

        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(systemName: "arrow.counterclockwise")
        configuration.imagePadding = 8
        configuration.title = "Reset"
        let resetButton = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            self?.resetRows()
        })

        let stackView = UIStackView(arrangedSubviews: [titleLabel, resetButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView()
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        return view
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.delete(row)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func tableView(
        _ tableView: UITableView,
        targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
        toProposedIndexPath proposedDestinationIndexPath: IndexPath
    ) -> IndexPath {
        IndexPath(row: proposedDestinationIndexPath.row, section: DemoSection.main.rawValue)
    }
}

private final class DemoDataSource: UITableViewDiffableDataSource<DemoSection, DemoRow> {
    var deleteHandler: ((DemoRow) -> Void)?
    var moveHandler: ((IndexPath, IndexPath) -> Void)?

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete,
              let row = itemIdentifier(for: indexPath)
        else { return }

        deleteHandler?(row)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        moveHandler?(sourceIndexPath, destinationIndexPath)
    }
}

private enum DemoSection: Int, Sendable {
    case main
}

private enum DemoCell {
    static let reuseIdentifier = "DemoRowCell"

    static func configure(_ cell: UITableViewCell, with row: DemoRow) {
        var content = UIListContentConfiguration.subtitleCell()
        content.text = row.title
        content.secondaryText = row.detail
        content.textProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .subheadline)
        content.secondaryTextProperties.color = .secondaryLabel
        content.image = UIImage(systemName: row.symbolName)
        content.imageProperties.tintColor = row.tone.color
        content.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 20,
            weight: .semibold
        )

        cell.contentConfiguration = content
        cell.selectionStyle = .none
        cell.showsReorderControl = true
        cell.tintColor = row.tone.color

        var background = UIBackgroundConfiguration.listGroupedCell()
        background.backgroundColor = .secondarySystemGroupedBackground
        cell.backgroundConfiguration = background
    }
}

private struct DemoRow: Hashable, Sendable {
    let id: UUID
    let title: String
    let detail: String
    let symbolName: String
    let tone: DemoTone

    static func initialRows() -> [DemoRow] {
        [
            DemoRow(
                title: "Stable Identifiers",
                detail: "UUID-backed row identity",
                symbolName: "number.square",
                tone: .blue
            ),
            DemoRow(
                title: "Cell Registration",
                detail: "Reusable content configuration",
                symbolName: "rectangle.stack",
                tone: .teal
            ),
            DemoRow(
                title: "Snapshot Apply",
                detail: "Animated insert and delete",
                symbolName: "arrow.triangle.2.circlepath",
                tone: .indigo
            ),
            DemoRow(
                title: "Swipe Delete",
                detail: "Destructive trailing action",
                symbolName: "trash",
                tone: .red
            ),
            DemoRow(
                title: "Reorder Rows",
                detail: "Editing-mode move support",
                symbolName: "line.3.horizontal",
                tone: .orange
            ),
            DemoRow(
                title: "Reset State",
                detail: "Fresh snapshot from seed data",
                symbolName: "arrow.counterclockwise",
                tone: .green
            ),
        ]
    }

    static func custom(number: Int) -> DemoRow {
        DemoRow(
            title: "Custom Row \(number)",
            detail: "Inserted at the top",
            symbolName: "plus.circle",
            tone: DemoTone.allCases[number % DemoTone.allCases.count]
        )
    }

    private init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        symbolName: String,
        tone: DemoTone
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.symbolName = symbolName
        self.tone = tone
    }
}

private enum DemoTone: Int, CaseIterable, Hashable, Sendable {
    case blue
    case teal
    case indigo
    case red
    case orange
    case green

    var color: UIColor {
        switch self {
        case .blue:
            UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return .systemBlue
                }

                return UIColor(red: 0.0, green: 0.34, blue: 0.72, alpha: 1.0)
            }
        case .teal:
            UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return .systemTeal
                }

                return UIColor(red: 0.04, green: 0.5, blue: 0.49, alpha: 1.0)
            }
        case .indigo:
            .systemIndigo
        case .red:
            .systemRed
        case .orange:
            .systemOrange
        case .green:
            .systemGreen
        }
    }
}

private final class SummaryHeaderView: UIView {
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let countPill = PillLabel()
    private let statusPill = PillLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
        backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .secondarySystemGroupedBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.cornerCurve = .continuous
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 12
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)

        titleLabel.text = "UITableView Diffable"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label
        titleLabel.adjustsFontForContentSizeCategory = true

        subtitleLabel.text = "Snapshot-backed rows"
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.adjustsFontForContentSizeCategory = true

        countPill.textColor = .secondaryLabel
        countPill.backgroundColor = .tertiarySystemGroupedBackground

        statusPill.textColor = DemoTone.teal.color
        statusPill.backgroundColor = .tertiarySystemGroupedBackground

        let pillStack = UIStackView(arrangedSubviews: [countPill, statusPill])
        pillStack.axis = .horizontal
        pillStack.alignment = .leading
        pillStack.spacing = 8

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, pillStack])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 8

        addSubview(cardView)
        cardView.addSubview(textStack)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),

            textStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            textStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            textStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            textStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(rowCount: Int, status: String) {
        let suffix = rowCount == 1 ? "row" : "rows"
        countPill.text = "\(rowCount) \(suffix)"
        statusPill.text = status
    }
}

private final class PillLabel: UILabel {
    private let contentInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)

        font = .preferredFont(forTextStyle: .caption1)
        adjustsFontForContentSizeCategory = true
        numberOfLines = 1
        textAlignment = .center
        clipsToBounds = true
        layer.cornerRadius = 13
        layer.cornerCurve = .continuous
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
}
