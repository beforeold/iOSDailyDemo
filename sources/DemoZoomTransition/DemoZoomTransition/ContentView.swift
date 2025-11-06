import SwiftUI
import UIKit

// 自定义 Zoom Transition
extension AnyTransition {
  static var zoomTransition: AnyTransition {
    .scale.combined(with: .opacity)
  }
}

// 图片模型：包含图片名称和颜色
struct ImageModel: Identifiable, Hashable {
  let id: String
  let imageName: String
  let color: Color
  
  init(imageName: String, color: Color? = nil) {
    self.id = imageName
    self.imageName = imageName
    self.color = color ?? imageName.randomColor
  }
  
  // Hashable 协议实现
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
    lhs.id == rhs.id
  }
}

// 扩展：为字符串生成稳定的随机颜色
extension String {
  var randomColor: Color {
    // 使用字符串的哈希值生成稳定的颜色
    var hasher = Hasher()
    hasher.combine(self)
    let hash = abs(hasher.finalize())
    
    // 生成 HSV 颜色，确保颜色鲜艳且可见
    let hue = Double(hash % 360) / 360.0
    let saturation = 0.6 + Double((hash / 360) % 20) / 100.0 // 0.6 到 0.8
    let brightness = 0.7 + Double((hash / 7200) % 20) / 100.0 // 0.7 到 0.9
    return Color(hue: hue, saturation: saturation, brightness: brightness)
  }
}

// SwiftUI View 用于在 Cell 中显示图片
struct ImageCellView: View {
  let model: ImageModel
  let namespace: Namespace.ID
  
  // 根据图片 ID 生成不同的高度比例（模拟不同尺寸的图片）
  private var aspectRatio: CGFloat {
    var hasher = Hasher()
    hasher.combine(model.id)
    let hash = abs(hasher.finalize())
    // 返回 0.8 到 1.6 之间的比例
    return 0.8 + CGFloat(hash % 80) / 100.0
  }

  var body: some View {
    ZStack {
      // 背景
      RoundedRectangle(cornerRadius: 8)
        .fill(model.color.opacity(0.1))
      
      // 图片，自适应大小，根据 aspectRatio 决定高度
      Image(systemName: model.imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(model.color)
        .matchedTransitionSource(id: model.id, in: namespace)
        .padding(8)
    }
    .aspectRatio(1.0 / aspectRatio, contentMode: .fit)
    .visualEffect { content, geometry in

      let frame = geometry.frame(in: .global)
      let screenHeight = UIScreen.main.bounds.height
      let screenCenter = screenHeight / 2
      let viewCenter = frame.midY
      
      // 计算距离屏幕中心的距离比例
      let distance = abs(viewCenter - screenCenter)
      let maxDistance = screenHeight / 2
      let normalizedDistance = min(distance / maxDistance, 1.0)
      
      // 基于距离计算透明度和缩放（越远越小越透明）
      let opacity = 1.0 - normalizedDistance * 0.4
      let scale = 1.0 - normalizedDistance * 0.1

      print("visual effect", opacity, scale * 0.33)

      return content
        .opacity(opacity)
        .scaleEffect(scale)
    }
  }
}

// 大图详情视图
struct ImageDetailView: View {
  let model: ImageModel
  let namespace: Namespace.ID
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ZStack {
      // 黑色背景
      Color.black.ignoresSafeArea()

      VStack {
        Spacer()

        // 大图，使用 NavigationTransition 实现从 cell 开始的 zoom 过渡
        Image(systemName: model.imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .foregroundColor(model.color)
          .padding(40)

        Spacer()
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.hidden, for: .navigationBar)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          dismiss()
        }) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.white)
            .font(.system(size: 24))
        }
      }
    }
  }
}

// UICollectionView 的 Representable
struct CollectionViewRepresentable: UIViewRepresentable {
  let items: [ImageModel]
  let namespace: Namespace.ID
  let navigationPath: Binding<NavigationPath>

  func makeUIView(context: Context) -> UICollectionView {
    // 使用瀑布流布局
    let layout = WaterfallLayout()
    layout.columnCount = 2
    layout.minimumColumnSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // 设置 self-sizing 测量闭包
    let coordinator = context.coordinator
    layout.sizeForItem = { indexPath, itemWidth in
      coordinator.measureCellSize(at: indexPath, width: itemWidth)
    }

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = context.coordinator
    collectionView.dataSource = context.coordinator
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

    return collectionView
  }

  func updateUIView(_ uiView: UICollectionView, context: Context) {
    // 当 bounds 改变时，需要重新计算布局
    if let layout = uiView.collectionViewLayout as? WaterfallLayout {
      layout.invalidateItemSizes()
      context.coordinator.sizeCache.removeAll()
      layout.invalidateLayout()
    }
    uiView.reloadData()
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    let parent: CollectionViewRepresentable
    
    // 缓存测量的大小
    var sizeCache: [IndexPath: CGSize] = [:]

    init(_ parent: CollectionViewRepresentable) {
      self.parent = parent
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return parent.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

      // 使用 UIHostingConfiguration 配置 cell
      let model = parent.items[indexPath.item]
      cell.contentConfiguration = UIHostingConfiguration {
        ImageCellView(model: model, namespace: parent.namespace)
          .onAppear {
            print("apppppear", model)
          }
          .onDisappear {
            print("dissssssssssss", model)
          }
      }

      return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let model = parent.items[indexPath.item]
      parent.navigationPath.wrappedValue.append(model)
    }
    
    // 测量 cell 的大小（self-sizing）
    func measureCellSize(at indexPath: IndexPath, width: CGFloat) -> CGSize {
      // 检查缓存
      if let cachedSize = sizeCache[indexPath] {
        return cachedSize
      }
      
      // 创建临时 cell 进行测量
      let cell = UICollectionViewCell()
      let model = parent.items[indexPath.item]
      
      // 使用 UIHostingConfiguration 配置 cell
      cell.contentConfiguration = UIHostingConfiguration {
        ImageCellView(model: model, namespace: parent.namespace)
          .frame(width: width)
      }
      
      // 使用 systemLayoutSizeFitting 测量大小
      let targetSize = CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)
      let size = cell.contentView.systemLayoutSizeFitting(
        targetSize,
        withHorizontalFittingPriority: .required,
        verticalFittingPriority: .fittingSizeLevel
      )
      
      // 缓存结果
      sizeCache[indexPath] = size
      
      return size
    }
  }
}

struct ContentView: View {
  // 示例数据：使用 ImageModel
  let imageModels: [ImageModel] = [
    ImageModel(imageName: "photo.fill"),
    ImageModel(imageName: "camera.fill"),
    ImageModel(imageName: "heart.fill"),
    ImageModel(imageName: "star.fill"),
    ImageModel(imageName: "bookmark.fill"),
    ImageModel(imageName: "bell.fill"),
    ImageModel(imageName: "flag.fill"),
    ImageModel(imageName: "tag.fill"),
    ImageModel(imageName: "folder.fill"),
    ImageModel(imageName: "paperclip"),
    ImageModel(imageName: "pencil"),
    ImageModel(imageName: "trash.fill"),
  ]

  @State private var navigationPath = NavigationPath()
  @Namespace private var imageNamespace

  var body: some View {
    NavigationStack(path: $navigationPath) {
      CollectionViewRepresentable(
        items: imageModels,
        namespace: imageNamespace,
        navigationPath: $navigationPath
      )
      .navigationTitle("图片集合")
      .navigationDestination(for: ImageModel.self) { model in
        ImageDetailView(
          model: model,
          namespace: imageNamespace
        )
        .navigationTransition(.zoom(sourceID: model.id, in: imageNamespace))
      }
    }
  }
}

#Preview {
  ContentView()
}
