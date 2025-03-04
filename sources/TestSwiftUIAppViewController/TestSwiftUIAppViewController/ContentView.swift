import SwiftUI

class FirstViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .yellow
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    print(self.view.bounds)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    print(self, #function)
  }
}

class SecondViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    print(self.view.bounds)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    print(self, #function)
  }
}

class Model: ObservableObject {
  @Published var selectedIndex = 0
}

struct ContentView: View {
  @StateObject private var model = Model()

  var body: some View {
    ZStack(alignment: .bottom) {
      HomeView(model: model)
        .ignoresSafeArea()

      Picker("", selection: $model.selectedIndex) {
        Text("First").tag(0)
        Text("Second").tag(1)
      }
      .pickerStyle(.segmented)
    }
  }
}

class MyPage: UIPageViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.trailingItemGroups = [.init(
      barButtonItems: [.init(title: "Me", image: nil, target: nil, action: nil)],
      representativeItem: nil
    )]
  }
}

struct HomeView: UIViewControllerRepresentable {
  @ObservedObject var model: Model

  class Coordinator: NSObject, UIPageViewControllerDelegate {
    //    func pageViewController(
    //      _ pageViewController: UIPageViewController,
    //      spineLocationFor orientation: UIInterfaceOrientation
    //    ) -> UIPageViewController.SpineLocation {
    //      .mid
    //    }

    lazy var first: UIViewController = {
      let vc = FirstViewController()

      return vc
    }()

    lazy var second: UIViewController = {
      let vc = SecondViewController()

      return vc
    }()
  }

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIViewController(context: Context) -> some UIViewController {
    let page = MyPage(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal
    )
    page.delegate = context.coordinator

    let nav = UINavigationController(rootViewController: page)

    return nav
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard let page = uiViewController.children.first as? UIPageViewController else {
      return
    }

    if model.selectedIndex == 0 {
      page.setViewControllers([context.coordinator.first], direction: .reverse, animated: true)
    } else {
      page.setViewControllers([context.coordinator.second], direction: .forward, animated: true)
    }
  }
}

#Preview {
  ContentView()
}
