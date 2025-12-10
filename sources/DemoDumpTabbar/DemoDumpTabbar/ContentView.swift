import SwiftUI
import UIKit
import ObjectiveC.runtime

struct ContentView: View {
    @State private var selectedIndex = 0
    private let tabItems: [UITabBarItem] = [
        UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0),
        UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1),
        UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 2)
    ]

    var body: some View {
        VStack {
            Text("Selected tab: \(tabItems[selectedIndex].title ?? "")")
                .font(.headline)
            UIKitTabBar(items: tabItems, selectedIndex: $selectedIndex)
                .frame(height: 60)
                .padding()
        }
        .onAppear {
            dumpUITabBarRuntime()
        }
    }
}

struct UIKitTabBar: UIViewRepresentable {
    var items: [UITabBarItem]
    @Binding var selectedIndex: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITabBar {
        let tabBar = UITabBar(frame: .zero)
        tabBar.items = items
        if selectedIndex < items.count {
            tabBar.selectedItem = items[selectedIndex]
        }
        tabBar.delegate = context.coordinator
        setMinimizedIfAvailable(tabBar, minimized: true)
        return tabBar
    }

    func updateUIView(_ uiView: UITabBar, context: Context) {
        uiView.items = items
        if selectedIndex < items.count {
            uiView.selectedItem = items[selectedIndex]
        }
    }

    class Coordinator: NSObject, UITabBarDelegate {
        var parent: UIKitTabBar

        init(parent: UIKitTabBar) {
            self.parent = parent
        }

        func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            guard let items = tabBar.items,
                  let index = items.firstIndex(of: item) else { return }
            parent.selectedIndex = index
        }
    }
}

private func setMinimizedIfAvailable(_ tabBar: UITabBar, minimized: Bool) {
    let selector = NSSelectorFromString("_setMinimized:")
    guard tabBar.responds(to: selector), let imp = tabBar.method(for: selector) else {
        print("UITabBar does not respond to _setMinimized:")
        return
    }

    typealias Function = @convention(c) (AnyObject, Selector, Bool) -> Void
    let function = unsafeBitCast(imp, to: Function.self)
    function(tabBar, selector, minimized)
    print("Called _setMinimized: with value \(minimized)")
}

private func dumpUITabBarRuntime() {
    let cls: AnyClass = UITabBar.self

    var methodCount: UInt32 = 0
    var propertyCount: UInt32 = 0

    var methodNames: [String] = []
    if let methodList = class_copyMethodList(cls, &methodCount) {
        for idx in 0..<Int(methodCount) {
            let method = methodList[idx]
            let selector = method_getName(method)
            methodNames.append(NSStringFromSelector(selector))
        }
        free(methodList)
    }

    var propertyNames: [String] = []
    if let propertyList = class_copyPropertyList(cls, &propertyCount) {
        for idx in 0..<Int(propertyCount) {
            let property = propertyList[idx]
            let name = property_getName(property)
            propertyNames.append(String(cString: name))
        }
        free(propertyList)
    }

    print("UITabBar properties (\(propertyNames.count)):")
    print(propertyNames.sorted().joined(separator: ", "))

    print("UITabBar instance methods (\(methodNames.count)):")
    print(methodNames.sorted().joined(separator: ", "))
}

#Preview {
    ContentView()
}
