import UIKit

// 瀑布流布局实现
class WaterfallLayout: UICollectionViewLayout {
  // 列数
  var columnCount: Int = 2
  
  // 列间距
  var minimumColumnSpacing: CGFloat = 10
  
  // 行间距
  var minimumInteritemSpacing: CGFloat = 10
  
  // section 内边距
  var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  
  // 存储每列的高度
  private var columnHeights: [CGFloat] = []
  
  // 存储所有 item 的布局属性
  private var attributesCache: [UICollectionViewLayoutAttributes] = []
  
  // 存储每个 item 的大小（通过测量 cell 获得）
  private var itemSizes: [IndexPath: CGSize] = [:]
  
  // 内容高度
  private var contentHeight: CGFloat = 0
  
  // 用于测量 cell 大小的闭包
  var sizeForItem: ((IndexPath, CGFloat) -> CGSize)?
  
  // 计算内容大小
  override var collectionViewContentSize: CGSize {
    guard let collectionView = collectionView else {
      return .zero
    }
    
    let width = collectionView.bounds.width - sectionInset.left - sectionInset.right
    return CGSize(width: width, height: contentHeight)
  }
  
  // 准备布局
  override func prepare() {
    super.prepare()
    
    guard let collectionView = collectionView else {
      return
    }
    
    // 重置
    columnHeights = Array(repeating: sectionInset.top, count: columnCount)
    attributesCache.removeAll()
    contentHeight = sectionInset.top
    
    let itemWidth = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(columnCount - 1) * minimumColumnSpacing) / CGFloat(columnCount)
    
    // 遍历所有 item
    let itemCount = collectionView.numberOfItems(inSection: 0)
    for item in 0..<itemCount {
      let indexPath = IndexPath(item: item, section: 0)
      
      // 获取 item 大小（通过 self-sizing 测量）
      let itemSize: CGSize
      if let cachedSize = itemSizes[indexPath] {
        itemSize = cachedSize
      } else if let sizeForItem = sizeForItem {
        itemSize = sizeForItem(indexPath, itemWidth)
        itemSizes[indexPath] = itemSize
      } else {
        // 默认大小
        itemSize = CGSize(width: itemWidth, height: itemWidth)
      }
      
      // 找到最短的列
      var shortestColumnIndex = 0
      var shortestHeight = columnHeights[0]
      for (index, height) in columnHeights.enumerated() {
        if height < shortestHeight {
          shortestHeight = height
          shortestColumnIndex = index
        }
      }
      
      // 计算位置
      let x = sectionInset.left + CGFloat(shortestColumnIndex) * (itemWidth + minimumColumnSpacing)
      let y = columnHeights[shortestColumnIndex]
      
      // 创建布局属性
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
      attributesCache.append(attributes)
      
      // 更新列高度
      columnHeights[shortestColumnIndex] = y + itemSize.height + minimumInteritemSpacing
      
      // 更新内容高度
      contentHeight = max(contentHeight, columnHeights[shortestColumnIndex])
    }
    
    contentHeight += sectionInset.bottom - minimumInteritemSpacing
  }
  
  // 返回指定区域内的布局属性
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesCache.filter { $0.frame.intersects(rect) }
  }
  
  // 返回指定 indexPath 的布局属性
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesCache[indexPath.item]
  }
  
  // 当 bounds 改变时重新计算布局
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let collectionView = collectionView else {
      return false
    }
    if collectionView.bounds.width != newBounds.width {
      // 宽度改变时，清除缓存的大小
      itemSizes.removeAll()
      return true
    }
    return false
  }
  
  // 清除大小缓存
  func invalidateItemSizes() {
    itemSizes.removeAll()
  }
}

