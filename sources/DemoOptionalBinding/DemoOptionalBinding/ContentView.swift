import Combine
import Observation
import SwiftUI

// Optional 扩展，添加 isPresented 属性（包含 getter 和 setter）
extension Optional {
  var isPresented: Bool {
    get {
      self != nil
    }
    set {
      if newValue { return }
      self = nil
    }
  }
}

// Item 结构体，符合 Hashable 协议
struct Item: Hashable {
  let id: UUID
  let name: String

  init(id: UUID = UUID(), name: String) {
    self.id = id
    self.name = name
  }
}

// ObservableObject 类，包含可选的 Item 属性
class ItemViewModel: ObservableObject {
  @Published var item: Item?

  init(item: Item? = nil) {
    self.item = item
  }
}

struct ContentView: View {
  @StateObject private var viewModel = ItemViewModel()

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")

      Button("显示 Sheet") {
        viewModel.item = Item(name: "示例项目")
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
    .sheet(isPresented: $viewModel.item.isPresented) {
      SheetView()
    }
  }
}

struct SheetView: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    NavigationView {
      VStack {
        Text("这是 Sheet 视图")
          .font(.title2)
          .padding()
      }
      .navigationTitle("Sheet")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("完成") {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
