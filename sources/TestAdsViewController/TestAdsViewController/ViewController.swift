//
//  ViewController.swift
//  TestAdsViewController
//
//  Created by Brook_Mobius on 5/17/23.
//

import UIKit

class ViewController: AdsViewController {
  
  override func viewDidLoad() {
#if DEBUG
    imageFileURLList = AdsViewController.prepareFileURL()
#endif
    
    super.viewDidLoad()
  }
}

import SwiftUI

class AdsViewController: UIViewController {
  enum Section: Hashable {
    case main
  }
  
  typealias Item = URL
  
  var imageFileURLList: [URL] = [] {
    didSet {
      assert(imageFileURLList.count > 0)
    }
  }
  
  var onCloseCallback: () -> Void = { }
  
  private let viewModel: ViewModel = .init()
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  
  private var collectionView: UICollectionView!
  private var layout: UICollectionViewFlowLayout!
  
  /// time run in seconds
  private var timeRun: Int = 0
  private let durationPerImage = 2
  private let timerInterval: TimeInterval = 1
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.modalPresentationStyle = .fullScreen
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    
    setupTimer()
  }
  
  private func setupUI() {
    setupCollectionView()
    setupDataSource()
    
    setupCloseView()
  }
  
  private func setupTimer() {
    Timer.scheduledTimer(
      timeInterval: timerInterval,
      target: self,
      selector: #selector(onTimerTick),
      userInfo: nil,
      repeats: true
    )
    
    updateProgressInfo()
  }
  
  private func updateProgressInfo() {
    let total = imageFileURLList.count * durationPerImage
    let remainning = total - timeRun
    
    let progress = Double(timeRun) / Double(total)
    let text = "\(remainning)s"
    
    withAnimation {
      viewModel.progress = progress
      viewModel.remainningTimeText = text
    }
  }
  
  private func setupCloseView() {
    let length: CGFloat = 32
    
    let ring = CloseView(
      viewModel: viewModel
    )
      .frame(width: length, height: length)
    
    let closeVC = UIHostingController(rootView: ring)

    addChild(closeVC)
    
    let top = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    let safeAreaTop = max(16, top)
    
    view.addSubview(closeVC.view)
    closeVC.view.translatesAutoresizingMaskIntoConstraints = false
    closeVC.view.backgroundColor = .clear
    NSLayoutConstraint.activate([
      closeVC.view.widthAnchor.constraint(equalToConstant: length),
      closeVC.view.heightAnchor.constraint(equalToConstant: length),
      closeVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaTop),
      closeVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(onCloseEvent))
    closeVC.view.addGestureRecognizer(tap)
  }
  
  private func showProductView() {
    print(#function)
  }
  
  private func setupCollectionView() {
    let imageWidth: CGFloat = 1242
    let imageHeight: CGFloat = 2688
    let heightRatio = imageHeight / imageWidth
    let width = view.frame.width
    let height = width * heightRatio
    
    layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    layout.itemSize =  .init(width: width, height: height)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = self
    collectionView.isUserInteractionEnabled = false
    view.addSubview(collectionView)
    
#if DEBUG
    collectionView.isUserInteractionEnabled = true
    collectionView.backgroundColor = .lightGray
#endif
    
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.widthAnchor.constraint(equalToConstant: width),
      collectionView.heightAnchor.constraint(equalToConstant: height),
    ])
  }
  
  private func setupDataSource() {
    let cellRegis = UICollectionView.CellRegistration<AdsImageCell, Item> { cell, indexPath, itemIdentifier in
      cell.imageFileURL = itemIdentifier
    }
    
    dataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: cellRegis, for: indexPath, item: itemIdentifier)
    }
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(imageFileURLList)
    dataSource.apply(snapshot)
  }
}

extension AdsViewController {
  @objc func onCloseEvent() {
    #if DEBUG
    print(#function)
    collectionView.contentOffset = .zero
    #endif
    
    if viewModel.progress == 1 {
      self.onCloseCallback()
    }
  }
  
  @objc func onTimerTick(_ timer: Timer) {
    timeRun += 1
    
    updateProgressInfo()
    
    if timeRun == 3 {
      showProductView()
    }
    
    if timeRun == imageFileURLList.count * durationPerImage {
      timer.invalidate()
      print("over")
      return
    }
    
    if timeRun % durationPerImage == 0 {
      let index = timeRun / durationPerImage
      let indexPath = IndexPath(item: index, section: 0)
      collectionView.scrollToItem(
        at: indexPath,
        at: .centeredHorizontally,
        animated: true
      )
    }
  }
}

extension AdsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    
  }
}

fileprivate class AdsImageCell: UICollectionViewCell {
  var imageView: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
#if DEBUG
    contentView.backgroundColor = (0..<2).randomElement() == 0 ? .red : .blue
#endif
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var imageFileURL: URL! {
    didSet {
      updateImage()
    }
  }
  
  private func updateImage() {
    let imageFileURL = self.imageFileURL!
    imageView.image = nil
    DispatchQueue.global().async {
      guard let data = try? Data(contentsOf: imageFileURL) else {
        return
      }
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        
        self.imageView.image = image
      }
    }
  }
  
  private func setupUI() {
    imageView = UIImageView()
    imageView.frame = contentView.bounds
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    contentView.addSubview(imageView)
  }
}

extension AdsViewController {
  static func prepareFileURL() -> [URL] {
    let code = resourceLanguageCode()
    
    guard let bundlePath = Bundle.main.path(
      forResource: "pica_store_\(code)",
      ofType: "bundle"
    ) else {
      return []
    }
    
    // pica_store_1_1242x2688bb
    let range = (1...5).reversed()
    let fileURLList: [URL] = range.compactMap { seq in
      let name = "pica_store_\(seq)_1242x2688bb"
      if let url = Bundle(path: bundlePath)?.url(forResource: name, withExtension: "png", subdirectory: nil) {
        return url
      }
      return nil
    }
    
    return fileURLList
  }
  
  private static func resourceLanguageCode() -> String {
    guard let strings = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] else {
      return "en"
    }
    
    let codeList: [String] = strings.compactMap { string in
      if string.hasPrefix("pt") {
        return "pt"
      }
      
      if string.hasPrefix("en") {
        return "en"
      }
      
      return nil
    }
    
    let code = codeList.first ?? "en"
    return code
  }
}

extension AdsViewController {
  class ViewModel: ObservableObject {
    @Published var progress: Double = 0
    @Published var remainningTimeText: String = ""
  }
}


fileprivate struct CloseView: View {
  @ObservedObject var viewModel: AdsViewController.ViewModel
  
  var body: some View {
    if progress == 1 {
      closeView
    } else {
      progressView
    }
  }
  
  var progress: Double {
    return viewModel.progress
  }
  
  var text: String {
    return viewModel.remainningTimeText
  }
  
  var closeView: some View {
    ZStack {
      Circle()
        .foregroundColor(Color(UIColor(white: 0, alpha: 0.5)))
      
      Image(systemName: "xmark")
        .foregroundColor(.white)
    }
  }
  
  var progressView: some View {
    ZStack {
      // background
      Circle()
        .foregroundColor(Color(UIColor(white: 0, alpha: 0.5)))
      
      // unselected circle
      Circle()
        .stroke(lineWidth: 2)
        .foregroundColor(Color.clear)
      
      // selected circle
      Circle()
        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        .foregroundColor(.white)
        .rotationEffect(Angle(degrees: -90))
        .animation(.linear)
      
      Text(text)
        .font(.system(size: 13))
        .foregroundColor(.white)
    }
  }
}

#if DEBUG

struct CloseView_Previews: PreviewProvider {
  static var previews: some View {
    CloseView(
      viewModel: {
        let vm = AdsViewController.ViewModel()
        vm.progress = 0.8
        vm.remainningTimeText = "2s"
        return vm
      }()
    )
    .frame(width: 32, height: 32)
    .background(Color.gray)
  }
}

#endif
