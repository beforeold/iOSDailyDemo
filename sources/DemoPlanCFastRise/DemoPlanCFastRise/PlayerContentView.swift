import UIKit

/// 在 mini ↔ full 之间随 progress 插值的「PlayerView 内容」
///
/// 这是一个普通 UIView，自己不参与手势识别 / 不持有 FloatingPanel；
/// 调用方读手势进度后调用 `apply(progress:)`，由它统一驱动子元素的位置/尺寸/透明度。
///
/// progress = 0  → minibar 形态（artwork 小、贴左、title 在右）
/// progress = 1  → fullscreen 形态（artwork 居中大、title 居中下方）
final class PlayerContentView: UIView {

  let background = UIView()
  let artwork = UIImageView()
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let playButton = UIButton(type: .system)
  let progressLabel = UILabel()

  // Mini 态尺寸
  private let miniHeight: CGFloat = 64
  private let miniArtworkSize: CGFloat = 48
  private let miniArtworkLeading: CGFloat = 8

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  private func setup() {
    backgroundColor = .clear

    background.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.18, alpha: 1.0)
    background.layer.cornerRadius = 16
    background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    background.clipsToBounds = true
    addSubview(background)

    artwork.backgroundColor = .systemPink
    artwork.layer.cornerRadius = 6
    artwork.clipsToBounds = true
    artwork.contentMode = .scaleAspectFill
    artwork.image = Self.makeArtworkImage()
    addSubview(artwork)

    titleLabel.text = "Song Title"
    titleLabel.textColor = .white
    titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    addSubview(titleLabel)

    subtitleLabel.text = "Artist · Album"
    subtitleLabel.textColor = .white.withAlphaComponent(0.7)
    subtitleLabel.font = .systemFont(ofSize: 12)
    subtitleLabel.alpha = 0
    addSubview(subtitleLabel)

    playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    playButton.tintColor = .white
    playButton.contentVerticalAlignment = .fill
    playButton.contentHorizontalAlignment = .fill
    addSubview(playButton)

    progressLabel.text = "visualProgress = 0.00"
    progressLabel.textColor = .white.withAlphaComponent(0.6)
    progressLabel.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
    progressLabel.textAlignment = .center
    addSubview(progressLabel)
  }

  private static func makeArtworkImage() -> UIImage {
    let size = CGSize(width: 200, height: 200)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { ctx in
      let colors = [
        UIColor.systemPink.cgColor,
        UIColor.systemPurple.cgColor,
        UIColor.systemIndigo.cgColor,
      ] as CFArray
      let gradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: colors,
        locations: [0, 0.5, 1]
      )!
      ctx.cgContext.drawLinearGradient(
        gradient,
        start: .zero,
        end: CGPoint(x: size.width, y: size.height),
        options: []
      )
      let symbol = UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 80, weight: .bold))!
      let tinted = symbol.withTintColor(.white.withAlphaComponent(0.9), renderingMode: .alwaysOriginal)
      let rect = CGRect(
        x: (size.width - tinted.size.width) / 2,
        y: (size.height - tinted.size.height) / 2,
        width: tinted.size.width,
        height: tinted.size.height
      )
      tinted.draw(in: rect)
    }
  }

  /// progress: 0 (mini) → 1 (full)
  func apply(progress: CGFloat) {
    let p = max(0, min(1, progress))
    let b = bounds
    // 注意：本视图自身可能比可见区域大（路线 A 会让它的 top 溢出 surface），
    // 但内部布局以「可见区域 = bounds」为准，bounds 由调用方负责更新。

    // background 占满 bounds
    background.frame = b
    background.layer.cornerRadius = lerp(16, 0, p)

    // Mini: artwork 48x48 贴左居 mini 行；Full: 居中、变大
    let fullArtworkSide = min(b.width - 80, 280)
    let side = lerp(miniArtworkSize, fullArtworkSide, p)

    let miniCenterY = b.height - miniHeight / 2
    let fullCenterY = b.height * 0.32
    let centerY = lerp(miniCenterY, fullCenterY, p)

    let miniCenterX = miniArtworkLeading + miniArtworkSize / 2
    let fullCenterX = b.width / 2
    let centerX = lerp(miniCenterX, fullCenterX, p)

    artwork.frame = CGRect(
      x: centerX - side / 2,
      y: centerY - side / 2,
      width: side,
      height: side,
    )
    artwork.layer.cornerRadius = lerp(6, 12, p)

    // title
    let miniTitleSize: CGFloat = 15
    let fullTitleSize: CGFloat = 22
    titleLabel.font = .systemFont(ofSize: lerp(miniTitleSize, fullTitleSize, p), weight: .semibold)
    titleLabel.textAlignment = p < 0.5 ? .left : .center
    titleLabel.sizeToFit()
    let titleSize = titleLabel.intrinsicContentSize
    let titleMiniCenter = CGPoint(
      x: miniArtworkLeading + miniArtworkSize + 12 + titleSize.width / 2,
      y: b.height - miniHeight / 2 - 6,
    )
    let titleFullCenter = CGPoint(
      x: b.width / 2,
      y: fullCenterY + fullArtworkSide / 2 + 32,
    )
    titleLabel.center = CGPoint(
      x: lerp(titleMiniCenter.x, titleFullCenter.x, p),
      y: lerp(titleMiniCenter.y, titleFullCenter.y, p),
    )
    titleLabel.bounds.size = titleSize

    // subtitle: 仅 full 显示
    subtitleLabel.sizeToFit()
    subtitleLabel.alpha = max(0, (p - 0.5) * 2)
    subtitleLabel.center = CGPoint(
      x: b.width / 2,
      y: titleLabel.frame.maxY + 14,
    )

    // play button
    let buttonSide: CGFloat = lerp(24, 48, p)
    let buttonCenterX = lerp(b.width - 32, b.width / 2, p)
    let buttonCenterY = lerp(b.height - miniHeight / 2, b.height - 120, p)
    playButton.frame = CGRect(
      x: buttonCenterX - buttonSide / 2,
      y: buttonCenterY - buttonSide / 2,
      width: buttonSide,
      height: buttonSide,
    )

    // progress 调试标
    progressLabel.text = String(format: "visualProgress = %.2f", p)
    progressLabel.sizeToFit()
    progressLabel.alpha = 0.9
    progressLabel.center = CGPoint(
      x: b.width / 2,
      y: 24 + UIApplication.shared.statusBarFrameHeight,
    )
  }

  private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    a + (b - a) * t
  }
}

private extension UIApplication {
  var statusBarFrameHeight: CGFloat {
    connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.statusBarManager?.statusBarFrame.height }
      .max() ?? 20
  }
}
