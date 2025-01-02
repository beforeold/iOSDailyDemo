import SwiftUI

public enum Size: Int {
  case one
  case two
}

public enum Images: Int {
  case one
  case two
}

extension Optional: RawRepresentable where Wrapped == Images {
  public typealias RawValue = String

  public init?(rawValue: RawValue) {
    nil
  }

  public var rawValue: String {
    ""
  }
}



class ViewModel: ObservableObject {
  @AppStorage("size1") var size: Size = .one

  @AppStorage("images") var images: Images? = .one

  @AppStorage("count") var count = 0
}

struct ContentView: View {
  @ObservedObject var viewModel: ViewModel = .init()

  var body: some View {
    VStack {
      Text("count: \(viewModel.count)")

      Button("plus") {
        viewModel.count += 1
      }

      Button("plus defaults") {
        UserDefaults.standard.setValue(
          viewModel.count + 1,
          forKey: "count"
        )
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
