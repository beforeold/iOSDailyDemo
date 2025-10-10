import SwiftUI
import UIKit

struct DemoView: View {
  var body: some View {
    Menu {
      // Toggle(isOn: .constant(true)) {
      Button(action: {}) {
        // Label("下载 4K 图片", systemImage: "arrow.down.circle.fill")
        Text("下载 4K 图片")
        Text("3000x4096, 文件较大")
      }

      Button(action: {
        print("下载原尺寸")
      }) {
        // Label("下载原尺寸", systemImage: "arrow.down.circle.fill")
        Text("下载原尺寸")
        Text("400x960, 文件较小")
      }
    } label: {
      Image(systemName: "chevron.up")
        .font(.title2)
        .foregroundColor(.primary)
    }
    .menuOrder(.fixed)
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // 创建 SwiftUI 视图
    let demoView = DemoView()
    let hostingController = UIHostingController(rootView: demoView)

    // 添加为子视图控制器
    addChild(hostingController)
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)

    // 设置约束
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

}

// MARK: - SwiftUI Preview
#if DEBUG
  struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
      DemoView()
        .previewDisplayName("Demo Menu")
    }
  }
#endif
