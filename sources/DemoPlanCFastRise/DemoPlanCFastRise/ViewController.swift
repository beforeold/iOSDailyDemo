import UIKit

/// 入口菜单：选择路线 A / B 进入对应的 Demo
final class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Plan C · 两路线对比"

    let header = UILabel()
    header.text = "方案 C 体验 Demo"
    header.font = .preferredFont(forTextStyle: .title1)
    header.textAlignment = .center

    let subtitle = UILabel()
    subtitle.text = "FloatingPanel 实现「手势 150pt 内 minibar → fullscreen」"
    subtitle.textColor = .secondaryLabel
    subtitle.numberOfLines = 0
    subtitle.textAlignment = .center
    subtitle.font = .preferredFont(forTextStyle: .footnote)

    let buttonA = makeButton(
      title: "路线 A · FP 1:1 + 子视图溢出顶部",
      detail: "保留 FP 默认 pan；content 自己以 N 倍速向上「长出」surface",
      color: .systemBlue,
      action: #selector(openA),
    )
    let buttonB = makeButton(
      title: "路线 B · 禁用 FP pan + 自加 1:N pan",
      detail: "FP 仅负责吸附 / state；pan 与位移由我们接管",
      color: .systemPurple,
      action: #selector(openB),
    )

    let stack = UIStackView(arrangedSubviews: [header, subtitle, buttonA, buttonB])
    stack.axis = .vertical
    stack.spacing = 20
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
      stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  private func makeButton(title: String, detail: String, color: UIColor, action: Selector) -> UIButton {
    var config = UIButton.Configuration.tinted()
    config.baseForegroundColor = color
    config.baseBackgroundColor = color
    config.cornerStyle = .large
    config.titlePadding = 6
    config.contentInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)

    var titleAttr = AttributedString(title)
    titleAttr.font = .systemFont(ofSize: 17, weight: .semibold)
    titleAttr.foregroundColor = .label
    config.attributedTitle = titleAttr

    var detailAttr = AttributedString(detail)
    detailAttr.font = .systemFont(ofSize: 13, weight: .regular)
    detailAttr.foregroundColor = .secondaryLabel
    config.attributedSubtitle = detailAttr

    let btn = UIButton(configuration: config)
    btn.addTarget(self, action: action, for: .touchUpInside)
    btn.contentHorizontalAlignment = .leading
    return btn
  }

  @objc private func openA() {
    navigationController?.pushViewController(RouteAViewController(), animated: true)
  }

  @objc private func openB() {
    navigationController?.pushViewController(RouteBViewController(), animated: true)
  }
}
