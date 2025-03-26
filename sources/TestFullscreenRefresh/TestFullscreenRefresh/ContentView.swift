import Observation
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

@Observable
class ViewModel2 {
  @ObservationIgnored
  private var timer: Timer?

  var count = 0

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
//  let viewModel = ViewModel2()
//  @State private var count = 0

  var count: Int { viewModel.count }

  @State private var timer: Timer? = nil

  @State private var item: Item? = nil

  var body: some View {
    let _ = print("home body", count)

    VStack(spacing: 30) {
      Text("count: \(count)")

      Button("Detail") {
        item = Item(value: count)
      }
    }
    .sheet(item: $item) { item in
//      DetailView(value: item.value) {
//        viewModel.count += 100
//      }
      let _ = print("full screen closure")

      Text("detail value: \(item.value)")
        .onTapGesture {
//          viewModel.count += 100
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

    Text("detail value: \(value)")
      .onTapGesture {
//        dismiss()
        action()
      }
  }
}

#Preview {
  ContentView()
}
