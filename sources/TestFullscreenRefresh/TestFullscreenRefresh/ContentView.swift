import SwiftUI

struct Item: Identifiable {
  var id: Int { value }

  var value: Int
}

class ViewModel: ObservableObject {
  private var timer: Timer?

  @Published var count = 0

  func startTimer() {
    if timer == nil {
      timer = Timer.scheduledTimer(
        withTimeInterval: 2,
        repeats: true
      ) { _ in
        self.count += 1
      }
    }
  }
}

struct ContentView: View {
  @StateObject private var viewModel = ViewModel()
//  @State private var count = 0
  var count: Int {
    viewModel.count
  }

  @State private var timer: Timer? = nil

  @State private var showsDetail: Item? = nil

  var body: some View {
    let _ = print("home body", count)

    VStack(spacing: 30) {
      Text("count: \(count)")

      Button("Detail") {
        showsDetail = Item(value: count)
      }
    }
    .fullScreenCover(item: $showsDetail) { value in
      DetailView(value: value.value) {
        viewModel.count += 100
      }
    }
    .onAppear {
      viewModel.startTimer()
    }
  }

  private func startTimer() {
    if timer == nil {
      timer = Timer.scheduledTimer(
        withTimeInterval: 2,
        repeats: true
      ) { _ in
//        count += 1
      }
    }
  }
}

struct DetailView: View {
  @Environment(\.dismiss) private var dismiss

  var value: Int
  var action: () -> Void

  init(value: Int, action: @escaping () -> Void) {
    let _ = print("detail init", value)
    self.value = value
    self.action = action
  }

  var body: some View {
    let _ = print("detail body", value)

    Text("detqil: \(value)")
      .onTapGesture {
//        dismiss()
        action()
      }
  }
}

#Preview {
  ContentView()
}
