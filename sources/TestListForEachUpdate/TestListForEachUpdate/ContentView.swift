import SwiftUI

struct DataSource<T: Hashable>: RandomAccessCollection {
  var list: [T]

  typealias Index = Int

  typealias Element = T

  subscript(index: Int) -> T {
    list[index]
  }

  var startIndex: Int {
    0
  }

  var endIndex: Int {
    list.endIndex
  }

}

struct Item: Hashable {
  var number: Int
}

struct ContentView: View {
  @State private var dataSource: DataSource = .init(
    list: [1, 2, 3].map { Item(number: $0) }
  )

  var body: some View {
    VStack {
      List {
        ForEach(dataSource, id: \.self) { item in
          Text("\(item.number)")
        }
      }

      Button("Update") {
        dataSource.list = [1, 2, 3, 4, 5, 6].map { Item(number: $0) }
      }
    }
    .padding()
  }
}

//struct ListView: View {
//  @State var items = (0 ..< 50).map { Item(number: $0) }
//  var body: some View {
//    List {
//      ForEach(items) { item in
//        Text("\(item.number)")
//      }
//    }
//  }
//}

#Preview {
  ContentView()
}
