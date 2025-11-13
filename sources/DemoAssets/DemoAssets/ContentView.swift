import SwiftUI

// 需要替换一个模块中的一些 icons，有很多名称是一样的
// 需求是可以覆盖着部分的 icons
// 直接拖入的话，会产生 xx 1.assetset 的文件
// 因此新建一个工程，新创建一批新的 assetset
// 再减所有的 assetset 覆盖过去即可

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
