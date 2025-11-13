import SwiftUI
import UIKit

struct UIMenuSwiftUI: UIViewRepresentable {
    let title: String
    let children: [UIMenuElement]
    let initialSliderValue: Float
    let initialStepperValue: Double
    
    init(title: String, children: [UIMenuElement], initialSliderValue: Float = 0.5, initialStepperValue: Double = 1.0) {
        self.title = title
        self.children = children
        self.initialSliderValue = initialSliderValue
        self.initialStepperValue = initialStepperValue
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(initialSliderValue: initialSliderValue, initialStepperValue: initialStepperValue)
    }
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.showsMenuAsPrimaryAction = true
        
        // 创建 header view
        let headerView = MenuHeaderView(
            initialValue: context.coordinator.sliderValue,
            initialStepperValue: context.coordinator.stepperValue
        )
        let coordinator = context.coordinator
        headerView.onSliderValueChanged = { newValue in
            coordinator.sliderValue = newValue
        }
        headerView.onStepperValueChanged = { newValue in
            coordinator.stepperValue = newValue
        }
        coordinator.headerView = headerView
        
        // 创建 UIMenu
        let menu = UIMenu(title: "", children: children)
        
        // 设置 header view provider（使用 OC 接口）
        menu.setHeaderViewProvider { menu in
            // 更新 header view 的值
            if let header = coordinator.headerView {
                header.sliderValue = coordinator.sliderValue
                header.stepperValue = coordinator.stepperValue
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
            headerView.sliderValue = context.coordinator.sliderValue
            headerView.stepperValue = context.coordinator.stepperValue
        }
        
        // 重新创建 menu 以反映最新的 children
        let menu = UIMenu(title: "", children: children)
        
        menu.setHeaderViewProvider { menu in
            if let header = context.coordinator.headerView {
                header.sliderValue = context.coordinator.sliderValue
                header.stepperValue = context.coordinator.stepperValue
            }
            return context.coordinator.headerView ?? UIView()
        }
        
        uiView.menu = menu
    }
    
    class Coordinator {
        var sliderValue: Float
        var stepperValue: Double
        var headerView: MenuHeaderView?
        var button: UIButton?
        
        init(initialSliderValue: Float, initialStepperValue: Double) {
            self.sliderValue = initialSliderValue
            self.stepperValue = initialStepperValue
        }
        
        func resetValues() {
            sliderValue = 0.5
            stepperValue = 1.0
            headerView?.sliderValue = 0.5
            headerView?.stepperValue = 1.0
        }
    }
}
