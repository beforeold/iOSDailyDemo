import UIKit

private final class WaterfallLayoutInvalidationContext: UICollectionViewLayoutInvalidationContext {
  var shouldInvalidateEverything = false
  
  override var invalidateEverything: Bool {
    shouldInvalidateEverything || super.invalidateEverything
  }
}

// MARK: - 瀑布流 Cell 基类（支持 Self-sizing）
class WaterfallCollectionViewCell: UICollectionViewCell {
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    // 强制布局更新以获取准确的大小
    setNeedsLayout()
    layoutIfNeeded()
    
    // 使用 Auto Layout 计算实际需要的大小
    let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
    let autoLayoutSize = contentView.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
    
    // 更新布局属性的大小
    var newFrame = layoutAttributes.frame
    newFrame.size.height = ceil(autoLayoutSize.height)
    layoutAttributes.frame = newFrame
    
    return layoutAttributes
  }
}

// MARK: - 瀑布流布局实现
class WaterfallLayout: UICollectionViewLayout {
  override class var invalidationContextClass: AnyClass {
    WaterfallLayoutInvalidationContext.self
  }
  
  // MARK: - 配置属性
  
  // 列数
  var columnCount: Int = 2 {
    didSet {
      invalidateLayout()
    }
  }
  
  // 列间距
  var minimumColumnSpacing: CGFloat = 10 {
    didSet {
      invalidateLayout()
    }
  }
  
  // 行间距
  var minimumInteritemSpacing: CGFloat = 10 {
    didSet {
      invalidateLayout()
    }
  }
  
  // section 内边距
  var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
    didSet {
      invalidateLayout()
    }
  }
  
  // MARK: - 私有属性
  
  private var cachedAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
  private var orderedAttributes: [UICollectionViewLayoutAttributes] = []
  private var itemHeightCache: [IndexPath: CGFloat] = [:]
  private var contentHeight: CGFloat = 0
  private var needsFullReprepare = true
  
  // MARK: - 布局生命周期
  
  override var collectionViewContentSize: CGSize {
    guard let collectionView = collectionView else {
      return .zero
    }
    
    let width = collectionView.bounds.width
    return CGSize(width: width, height: contentHeight)
  }
  
  override func prepare() {
    super.prepare()
    
    guard needsFullReprepare, let collectionView = collectionView else {
      return
    }
    
    needsFullReprepare = false
    
    cachedAttributes.removeAll(keepingCapacity: true)
    orderedAttributes.removeAll(keepingCapacity: true)
    
    let adjustedInset = collectionView.adjustedContentInset
    let contentWidth = collectionView.bounds.width - adjustedInset.left - adjustedInset.right
    let resolvedColumnCount = max(columnCount, 1)
    let columnSpacing = max(minimumColumnSpacing, 0)
    let rowSpacing = max(minimumInteritemSpacing, 0)
    let totalColumnSpacing = CGFloat(max(resolvedColumnCount - 1, 0)) * columnSpacing
    let horizontalInset = sectionInset.left + sectionInset.right
    let usableWidth = max(contentWidth - horizontalInset - totalColumnSpacing, 0)
    let itemWidth = resolvedColumnCount > 0 ? usableWidth / CGFloat(resolvedColumnCount) : 0
    
    contentHeight = 0
    var validIndexPaths = Set<IndexPath>()
    
    let numberOfSections = collectionView.numberOfSections
    for section in 0..<numberOfSections {
      let itemsCount = collectionView.numberOfItems(inSection: section)
      let sectionTop = contentHeight + sectionInset.top
      
      guard itemsCount > 0 else {
        contentHeight = sectionTop + sectionInset.bottom
        continue
      }
      
      var columnHeights = Array(repeating: sectionTop, count: resolvedColumnCount)
      
      for item in 0..<itemsCount {
        let indexPath = IndexPath(item: item, section: section)
        validIndexPaths.insert(indexPath)
        
        let column = columnHeights.enumerated().min(by: { $0.element < $1.element }) ?? (offset: 0, element: sectionTop)
        let columnIndex = column.offset
        let yOffset = column.element
        let xOffset = sectionInset.left + CGFloat(columnIndex) * (itemWidth + columnSpacing)
        let cachedHeight = itemHeightCache[indexPath] ?? itemWidth
        let itemHeight = max(ceil(cachedHeight), 0)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
        
        cachedAttributes[indexPath] = attributes
        orderedAttributes.append(attributes)
        
        columnHeights[columnIndex] = attributes.frame.maxY + rowSpacing
      }
      
      let maxColumnHeight = columnHeights.max() ?? sectionTop
      let sectionBottom = maxColumnHeight - rowSpacing
      contentHeight = max(sectionBottom + sectionInset.bottom, contentHeight)
    }
    
    if numberOfSections == 0 {
      contentHeight = 0
    }
    
    itemHeightCache = itemHeightCache.filter { validIndexPaths.contains($0.key) }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    orderedAttributes.filter { $0.frame.intersects(rect) }
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    cachedAttributes[indexPath]
  }
  
  // MARK: - 处理 Self-sizing
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let collectionView = collectionView else { return false }
    let widthChanged = abs(collectionView.bounds.width - newBounds.width) > .ulpOfOne
    if widthChanged {
      needsFullReprepare = true
    }
    return widthChanged
  }
  
  override func shouldInvalidateLayout(
    forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
    withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
  ) -> Bool {
    // 只有当高度有显著变化时才失效
    let heightDelta = abs(preferredAttributes.frame.height - originalAttributes.frame.height)
    if heightDelta > 0.1 {
      needsFullReprepare = true
      return true
    }
    return false
  }
  
  override func invalidationContext(
    forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
    withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutInvalidationContext {
    let context = super.invalidationContext(
      forPreferredLayoutAttributes: preferredAttributes,
      withOriginalAttributes: originalAttributes
    )
    
    let indexPath = preferredAttributes.indexPath
    itemHeightCache[indexPath] = preferredAttributes.frame.height
    needsFullReprepare = true
    if let waterfallContext = context as? WaterfallLayoutInvalidationContext {
      waterfallContext.shouldInvalidateEverything = true
    }
    
    return context
  }
  
  override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayout(with: context)
    
    if context.invalidateDataSourceCounts {
      itemHeightCache.removeAll()
    }
    
    needsFullReprepare = true
  }
}
