import SwiftUI
import UIKit

struct ContentView: View {
  @State var quantity: Int = 1

  var body: some View {
    VStack(spacing: 20) {
      Text("UIMenu with Custom Header")
        .font(.title2)
        .fontWeight(.bold)
        .padding()
      
      // 使用 UIMenuSwiftUI wrapper，sliderValue 现在在内部管理
      Group {
        if #available(iOS 26.0, *) {
          UIMenuSwiftUI(
            title: "显示菜单",
            children: createMenuElements()
          )
          .glassEffect()
        } else {
          UIMenuSwiftUI(
            title: "显示菜单",
            children: createMenuElements()
          )
        }
      }
      .frame(width: 100, height: 50)
      .padding()
      
      // 显示当前值（只显示数量，sliderValue 不再需要显示）
      VStack(spacing: 10) {
        Text("数量: \(quantity)")
          .font(.headline)
      }
      .padding()
    }
    .padding()
  }
  
  private func createMenuElements() -> [UIMenuElement] {
    let incrementAction = UIAction(title: "增加数量") { _ in
      quantity += 1
    }
    
    let decrementAction = UIAction(title: "减少数量") { _ in
      if quantity > 0 {
        quantity -= 1
      }
    }
    
    let resetAction = UIAction(title: "重置") { _ in
      quantity = 1
    }
    
    return [incrementAction, decrementAction, resetAction]
  }
}

#Preview {
  ContentView()
}
