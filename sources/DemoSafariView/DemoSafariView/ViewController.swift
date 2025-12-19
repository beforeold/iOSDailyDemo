import SafariServices
import UIKit
import WebKit

class ViewController: UIViewController {
  // Demo list of YouTube video links you can preload or display later.
  private let youtubeVideoLinks: [String] = [
    "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    "https://www.youtube.com/watch?v=9bZkp7q19f0",
    "https://www.youtube.com/watch?v=3JZ_D3ELwOQ",
    "https://www.youtube.com/watch?v=RgKAFK5djSk",
    "https://www.youtube.com/watch?v=fRh_vgS2dFE",
    "https://www.youtube.com/watch?v=OPf0YbXqDm0",
    "https://www.youtube.com/watch?v=YVkUvmDQ3HY",
    "https://www.youtube.com/watch?v=lWA2pjMjpBs",
    "https://www.youtube.com/watch?v=uelHwf8o7_U",
    "https://www.youtube.com/watch?v=CevxZvSJLk8",
    "https://www.youtube.com/watch?v=2Vv-BfVoq4g",
    "https://www.youtube.com/watch?v=pRpeEdMmmQ0",
    "https://www.youtube.com/watch?v=ktvTqknDobU",
    "https://www.youtube.com/watch?v=hHUbLv4ThOo",
    "https://www.youtube.com/watch?v=5NV6Rdv1a3I",
    "https://www.youtube.com/watch?v=48rz8udZBmQ",
    "https://www.youtube.com/watch?v=gG_dA32oH44",
    "https://www.youtube.com/watch?v=kXYiU_JCYtU",
    "https://www.youtube.com/watch?v=hT_nvWreIhg",
    "https://www.youtube.com/watch?v=JGwWNGJdvx8"
  ]

  private let douyinVideoLinks: [String] = [
    "https://www.douyin.com/hot?modal_id=7581098923972922666&utm_source=chatgpt.com",
    "https://www.douyin.com/hot?modal_id=7583602096369372457&utm_source=chatgpt.com",
    "https://www.douyin.com/hot?modal_id=7556895376168324371&utm_source=chatgpt.com",
    "https://www.douyin.com/hot?modal_id=7554977225007779106&utm_source=chatgpt.com",
    "https://www.douyin.com/hot?modal_id=7570264319351361402&utm_source=chatgpt.com"
  ]

  private var allVideoLinks: [String] { douyinVideoLinks + youtubeVideoLinks }

  private let urlField: UITextField = {
    let field = UITextField()
    field.placeholder = "Enter a full link (https://example.com)"
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.borderStyle = .roundedRect
    field.keyboardType = .URL
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
  }()

  private let openButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Open in Safari View", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let pagerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Show WebView Pager", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let safariPagerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Show Safari VC Pager", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    view.addSubview(urlField)
    view.addSubview(openButton)
    view.addSubview(pagerButton)
    view.addSubview(safariPagerButton)
    openButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
    pagerButton.addTarget(self, action: #selector(openWebPager), for: .touchUpInside)
    safariPagerButton.addTarget(self, action: #selector(openSafariPager), for: .touchUpInside)

    NSLayoutConstraint.activate([
      urlField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      urlField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      urlField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      openButton.topAnchor.constraint(equalTo: urlField.bottomAnchor, constant: 16),
      openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      pagerButton.topAnchor.constraint(equalTo: openButton.bottomAnchor, constant: 12),
      pagerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      safariPagerButton.topAnchor.constraint(equalTo: pagerButton.bottomAnchor, constant: 12),
      safariPagerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  @objc
  private func openLink() {
    guard let text = urlField.text, let url = URL(string: text.trimmingCharacters(in: .whitespacesAndNewlines)), UIApplication.shared.canOpenURL(url) else {
      presentAlert(message: "Please enter a valid URL, including scheme (e.g. https://example.com).")
      return
    }

    let safariVC = SFSafariViewController(url: url)
    present(safariVC, animated: true)
  }

  @objc
  private func openWebPager() {
    let pager = WebPagerViewController(links: allVideoLinks)
    pager.modalPresentationStyle = .fullScreen
    present(pager, animated: true)
  }

  @objc
  private func openSafariPager() {
    let pager = SafariEmbeddedPagerViewController(links: allVideoLinks)
    pager.modalPresentationStyle = .fullScreen
    present(pager, animated: true)
  }

  private func presentAlert(message: String) {
    let alert = UIAlertController(title: "Invalid URL", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

final class WebPagerViewController: UIViewController {
  private let links: [String]

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .systemBackground
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  init(links: [String]) {
    self.links = links
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(WebPagerCell.self, forCellWithReuseIdentifier: WebPagerCell.reuseIdentifier)

    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

final class SafariEmbeddedPagerViewController: UIViewController {
  private var links: [String]

  private let switchButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Switch Link", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
    button.layer.cornerRadius = 8
    return button
  }()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .systemBackground
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  init(links: [String]) {
    self.links = links
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(SafariEmbeddedCell.self, forCellWithReuseIdentifier: SafariEmbeddedCell.reuseIdentifier)
    switchButton.addTarget(self, action: #selector(switchCurrentLink), for: .touchUpInside)

    view.addSubview(collectionView)
    view.addSubview(switchButton)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      switchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      switchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      switchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      switchButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }

  private func detachSafari(from cell: SafariEmbeddedCell) {
    guard let safari = cell.hostedSafari else { return }
    safari.willMove(toParent: nil)
    safari.view.removeFromSuperview()
    safari.removeFromParent()
    cell.clearHostedSafari()
  }

  @objc
  private func switchCurrentLink() {
    guard let indexPath = visibleIndexPath() else { return }
    guard !links.isEmpty else { return }

    let currentLink = links[indexPath.item]
    var newLink = currentLink
    if links.count > 1 {
      repeat {
        newLink = links.randomElement() ?? currentLink
      } while newLink == currentLink
    }
    links[indexPath.item] = newLink

    if let cell = collectionView.cellForItem(at: indexPath) as? SafariEmbeddedCell {
      detachSafari(from: cell)
      if let url = URL(string: newLink) {
        let safariVC = SFSafariViewController(url: url)
        addChild(safariVC)
        cell.embedSafari(safariVC)
        safariVC.didMove(toParent: self)
      }
    } else {
      collectionView.reloadItems(at: [indexPath])
    }
  }

  private func visibleIndexPath() -> IndexPath? {
    let center = CGPoint(x: collectionView.bounds.midX + collectionView.contentOffset.x,
                         y: collectionView.bounds.midY + collectionView.contentOffset.y)
    return collectionView.indexPathForItem(at: center)
  }
}

extension SafariEmbeddedPagerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    links.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SafariEmbeddedCell.reuseIdentifier, for: indexPath) as? SafariEmbeddedCell else {
      return UICollectionViewCell()
    }
    detachSafari(from: cell)
    let link = links[indexPath.item]
    if let url = URL(string: link) {
      let safariVC = SFSafariViewController(url: url)
      addChild(safariVC)
      cell.embedSafari(safariVC)
      safariVC.didMove(toParent: self)
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? SafariEmbeddedCell else { return }
    detachSafari(from: cell)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
  }
}

private final class SafariEmbeddedCell: UICollectionViewCell {
  static let reuseIdentifier = "SafariEmbeddedCell"

  weak var hostedSafari: SFSafariViewController?

  private let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .secondarySystemBackground
    contentView.addSubview(containerView)

    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func embedSafari(_ safari: SFSafariViewController) {
    hostedSafari = safari
    let safariView = safari.view!
    safariView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(safariView)
    NSLayoutConstraint.activate([
      safariView.topAnchor.constraint(equalTo: containerView.topAnchor),
      safariView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      safariView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      safariView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
  }

  func clearHostedSafari() {
    hostedSafari = nil
    containerView.subviews.forEach { $0.removeFromSuperview() }
  }
}
extension WebPagerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    links.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPagerCell.reuseIdentifier, for: indexPath) as? WebPagerCell else {
      return UICollectionViewCell()
    }
    cell.load(link: links[indexPath.item])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
  }
}

private final class WebPagerCell: UICollectionViewCell {
  static let reuseIdentifier = "SafariPagerCell"

  private let webView: WKWebView = {
    let configuration = WKWebViewConfiguration()
    configuration.allowsInlineMediaPlayback = true
    configuration.mediaTypesRequiringUserActionForPlayback = []
    let view = WKWebView(frame: .zero, configuration: configuration)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.scrollView.isScrollEnabled = true
    view.scrollView.bounces = false
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .secondarySystemBackground
    contentView.addSubview(webView)

    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: contentView.topAnchor),
      webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func load(link: String) {
    if let url = URL(string: link) {
      webView.load(URLRequest(url: url))
    } else {
      webView.loadHTMLString("<html><body><p>Invalid URL</p></body></html>", baseURL: nil)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    webView.stopLoading()
    webView.loadHTMLString("", baseURL: nil)
  }
}
