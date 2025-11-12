import SwiftUI
import UIKit

struct UIMenuSwiftUI: UIViewRepresentable {
    let title: String
    let children: [UIMenuElement]
    let initialSliderValue: Float
    
    init(title: String, children: [UIMenuElement], initialSliderValue: Float = 0.5) {
        self.title = title
        self.children = children
        self.initialSliderValue = initialSliderValue
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(initialValue: initialSliderValue)
    }
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.showsMenuAsPrimaryAction = true
        
        // 创建 header view
        let headerView = MenuHeaderView(initialValue: context.coordinator.sliderValue)
        let coordinator = context.coordinator
        headerView.onValueChanged = { newValue in
            coordinator.sliderValue = newValue
        }
        coordinator.headerView = headerView
        
        // 创建 UIMenu
        let menu = UIMenu(title: "", children: children)
        
        // 设置 header view provider（使用 OC 接口）
        menu.setHeaderViewProvider { menu in
            // 更新 header view 的值
            if let header = coordinator.headerView {
                header.value = coordinator.sliderValue
            }
            return coordinator.headerView ?? UIView()
        }
        
        button.menu = menu
        coordinator.button = button
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        // 更新 header view 的值
        if let headerView = context.coordinator.headerView {
            headerView.value = context.coordinator.sliderValue
        }
        
        // 重新创建 menu 以反映最新的 children
        let menu = UIMenu(title: "", children: children)
        
        menu.setHeaderViewProvider { menu in
            if let header = context.coordinator.headerView {
                header.value = context.coordinator.sliderValue
            }
            return context.coordinator.headerView ?? UIView()
        }
        
        uiView.menu = menu
    }
    
    class Coordinator {
        var sliderValue: Float
        var headerView: MenuHeaderView?
        var button: UIButton?
        
        init(initialValue: Float) {
            self.sliderValue = initialValue
        }
        
        func resetSliderValue() {
            sliderValue = 0.5
            headerView?.value = 0.5
        }
    }
}

