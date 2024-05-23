//
//  ContentView.swift
//  TestSwiftUIIdentity
//
//  Created by xipingping on 3/20/24.
//

import SwiftUI

struct ItemModel: Hashable, Identifiable {
  var id: UUID
}

struct ContentView: View {
  @State var items: [ItemModel] = (0..<1000).map { _ in
    ItemModel(id: UUID())
  }

  init() {
    print("init content view")
  }

  var body: some View {
    List(items) { item in
//      LazyVGrid(columns: createGridColumns(), spacing: 15) {
//      ForEach(items, id: \.id) { item in
//          let item = items[index]
          let id = item.id
          ItemView(model: item)
            .id(id)
//        }
//      }
    }
  }

  func createGridColumns() -> [GridItem] {
    let columns = [
      GridItem(.adaptive(minimum: 152), spacing: 16)
    ]
    return columns
  }
}

class MyLabel: UILabel {
  deinit {
    print("mylabel deinit", self.text ?? "")
  }
}

struct ItemView: UIViewRepresentable {
  static var totalMakeCount = 0

  static var totalInitCount = 0

  typealias UIViewType = UILabel

  func makeUIView(context: Context) -> UILabel {
    ItemView.totalMakeCount += 1

    let countString = String(format: "%03d", ItemView.totalMakeCount)
    print("make \(countString)", model.id)

    return MyLabel()
  }

  func updateUIView(_ uiView: UILabel, context: Context) {
    print("update", model.id)

    uiView.text = model.id.description
    uiView.backgroundColor = .black
    uiView.textColor = .white
  }

  var model: ItemModel

  init(
    model: ItemModel
  ) {
    self.model = model

    ItemView.totalInitCount += 1

    let countString = String(format: "%03d", ItemView.totalInitCount)
    print("init \(countString)", model.id)

    print("init", model.id)
  }

}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
