import SwiftUI
import SwiftData

struct Service {
  static func request() async throws -> String {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    return "666"
  }
}

@discardableResult public func withEvents<T>(
  action: () async throws -> T,
  start: (Date) -> Void = { _ in },
  success: @MainActor (_ beginTimestamp: TimeInterval, T) -> Void,
  failure: (_ beginTimestamp: TimeInterval, _ error: Error) -> Void
) async rethrows -> T {
  let date = Date()
  let timestamp = date.timeIntervalSince1970
  start(date)

  do {
    let result = try await action()
    await success(timestamp, result)
    return result
  } catch {
    failure(timestamp, error)
    throw error
  }
}

@MainActor
class ViewModel: ObservableObject {

  func foo() async {
//    print("foo begin", Thread.current)

    do {
      let ret = try await withEvents(
        action: {
//          print("action thread", Thread.current)
          return try await Service.request()
        },
        start: { date in
          print("start thread", Thread.current)
        },
        success: { @MainActor stamp, value in
          print("success thread", Thread.current)
        },
        failure: { stamp, error in
          print("failure thread", Thread.current)
        }
      )
//      print("get ret", ret, Thread.current)
    } catch {
      print("failed to request", error)
    }
  }
}

struct ContentView: View {
  @ObservedObject private var viewModel = ViewModel()

  @Environment(\.modelContext) private var modelContext

  @Query private var items: [Item]

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(items) { item in
          NavigationLink {
            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
          } label: {
            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
          }
        }
        .onDelete(perform: deleteItems)
      }
      .task {
        await viewModel.foo()
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    } detail: {
      Text("Select an item")
    }
  }

  private func addItem() {
    withAnimation {
      let newItem = Item(timestamp: Date())
      modelContext.insert(newItem)
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
