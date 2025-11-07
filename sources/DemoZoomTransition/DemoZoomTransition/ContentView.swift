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
    // 返回 0.6 到 1.5 之间的比例（更大的范围，更明显的差异）
    return 0.6 + CGFloat(hash % 90) / 100.0
  }

  var body: some View {
    VStack(spacing: 0) {
      // 使用颜色块来模拟不同高度的内容
      RoundedRectangle(cornerRadius: 8)
        // .fill(model.color.opacity(0.1))

      // 图片，自适应大小，根据 aspectRatio 决定高度
      Image(systemName: model.imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(model.color)
        .matchedTransitionSource(id: model.id, in: namespace)
        .padding(8)
    }
    .aspectRatio(1.0 / aspectRatio, contentMode: .fit)
    .background(Color.gray)
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

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = context.coordinator
    collectionView.dataSource = context.coordinator
    collectionView.register(WaterfallCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

    return collectionView
  }

  func updateUIView(_ uiView: UICollectionView, context: Context) {
    uiView.reloadData()
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    let parent: CollectionViewRepresentable

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
      }

      return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let model = parent.items[indexPath.item]
      parent.navigationPath.wrappedValue.append(model)
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
