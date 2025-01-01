import SwiftUI

extension EnvironmentObject {
  public init(_ type: ObjectType.Type) {
    self.init()
  }
}

struct SecondView: View {
  @EnvironmentObject private var viewModel: ViewModel

  @EnvironmentObject(ViewModel.self) private var vm2

  var body: some View {
    Text("Hello, World! \(viewModel.count)")
  }
}

#Preview("first", traits: .modifier(GlobalModifier(name: "first"))) {
//#Preview {
  SecondView()
}

//#Preview("second", traits: .modifier(GlobalModifier(name: "second"))) {
////#Preview {
//  SecondView().environmentObject(ViewModel())
//}
