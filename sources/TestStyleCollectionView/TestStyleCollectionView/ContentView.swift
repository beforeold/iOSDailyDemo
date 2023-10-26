//
//  ContentView.swift
//  TestStyleCollectionView
//
//  Created by Brook_Mobius on 10/26/23.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      PurchaseStyleCardListView()
        .frame(height: PurchaseStyleCardListView.StyleCell.height)
    }
  }
}

#Preview {
  ContentView()
}

struct PurchaseStyleCardListView: UIViewRepresentable {
  typealias StyleCell = PurchaseStyleCollectionView.StyleCell

  class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
      _ collectionView: UICollectionView,
      numberOfItemsInSection section: Int
    ) -> Int {
      4 * 800
    }

    func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PurchaseStyleCollectionView.StyleCell.id,
        for: indexPath
      )
      cell.backgroundColor = .blue

      let tag = 333
      if let view = cell.contentView.viewWithTag(tag), let label = view as? UILabel {
        label.text = "\(indexPath.item)"
      } else {
        let label = UILabel()
        label.frame = cell.contentView.bounds
        label.text = "\(indexPath.item)"
        label.textColor = .white
        label.textAlignment = .center
        label.tag = tag
        cell.contentView.addSubview(label)
      }

      return cell
    }

    func scrollViewWillEndDragging(
      _ scrollView: UIScrollView,
      withVelocity velocity: CGPoint,
      targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
      print(#function, "from \(scrollView.contentOffset.x) -> \(targetContentOffset.pointee.x)")

      if targetContentOffset.pointee.x < StyleCell.width {
        return
      }

      targetContentOffset.pointee.x = scrollView.contentOffset.x + StyleCell.width
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIView(context: Context) -> PurchaseStyleCollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = .init(width: StyleCell.width, height: StyleCell.height)
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = StyleCell.spacing
    layout.minimumInteritemSpacing = StyleCell.spacing
    layout.sectionInset = .init(top: 0, left: StyleCell.edge, bottom: 0, right: StyleCell.edge)

    let uiView = PurchaseStyleCollectionView(frame: .zero, collectionViewLayout: layout)
    uiView.showsHorizontalScrollIndicator = false
    uiView.delegate = context.coordinator
    uiView.dataSource = context.coordinator
    uiView.decelerationRate = .normal
    uiView.register(
      PurchaseStyleCollectionView.StyleCell.self,
      forCellWithReuseIdentifier: PurchaseStyleCollectionView.StyleCell.id
    )

    return uiView
  }

  func updateUIView(
    _ uiView: PurchaseStyleCollectionView,
    context: Context
  ) {
    print(#function, "contentSize", uiView.contentSize)
  }
}

class PurchaseStyleCollectionView: UICollectionView {
  private var hasFirstScrolled = false
  private var timer: Timer?

  class StyleCell: UICollectionViewCell {
    static let id = "StyleCell"

    static let edge: CGFloat = 20
    static let spacing: CGFloat = 12

    static let width: CGFloat = 100
    static let height: CGFloat = 135
  }

  deinit {
    timer?.invalidate()
  }

  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    print(#function, "contentSize", self.contentSize)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    if hasFirstScrolled {
      return
    } else {
      startTimer()
      hasFirstScrolled = true
    }
  }

  private func startTimer() {
    timer = Timer.scheduledTimer(
      withTimeInterval: 0.05,
      repeats: true
    ) { [weak self] _ in
      self?.onTimer()
    }
  }

  private func onTimer() {
    let toX = contentOffset.x + 15
    self.setContentOffset(CGPoint(x: toX, y: 0), animated: true)
  }

  private func firstScrollIfNeeded() {
    if hasFirstScrolled {
      return
    }

    print(#function, "contentSize", self.contentSize)

    contentOffset = CGPoint(
      x: 4 * (StyleCell.width + StyleCell.spacing) + StyleCell.edge,
      y: 0
    )
    hasFirstScrolled = true
  }
}
