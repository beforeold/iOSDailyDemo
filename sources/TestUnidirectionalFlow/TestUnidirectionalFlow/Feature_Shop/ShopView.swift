//
//  ShopView.swift
//  TestUnidirectionalFlow
//
//  Created by Brook_Mobius on 11/1/23.
//

import SwiftUI

struct ShopView: View {
  @ObservedObject var store = ShopStore(
    initialState: .init(
      products: [
        "product 1",
        "product 2",
        "product 3",
        "product 4",
        "product 5",
        "product 6"
      ]
    ),
    reduce: reduce
  )

  var body: some View {
    NavigationView {
      List(store.state.products, id: \.self) { product in
        Text(verbatim: product)
          .swipeActions {
            Button(role: .destructive) {
              store.send(.remove(product))
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
      }
      .navigationBarItems(trailing: addButton)
    }
  }

  private var addButton: some View {
    Button {
      store.send(
        .add("product \((100...1000).randomElement()!)")
      )
    } label: {
      Image(systemName: "plus")
    }
  }
}

struct ShopView_Preview: PreviewProvider {
  static var previews: some View {
    Group {
      ShopView(store: ShopStore(
        initialState: .init(
          products: [
            "product 1",
            "product 2",
            "product 3",
            "product 4",
            "product 5",
            "product 6"
          ]
        ),
        reduce: reduce
      ))

      ShopView(store: ShopStore(
        initialState: .init(
          products: [
          ]
        ),
        reduce: reduce
      ))

    }
    .preferredColorScheme(.dark)
  }
}

