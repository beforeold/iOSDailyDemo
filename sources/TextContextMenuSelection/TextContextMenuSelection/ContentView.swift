//
//  ContentView.swift
//  TextContextMenuSelection
//
//  Created by beforeold on 7/6/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ContextMenuItemExample(
      items: [
        .init(name: "1"),
        .init(name: "2"),
        .init(name: "3"),
        .init(name: "4"),
      ]
    )
  }
}

#Preview {
  ContentView()
}

struct ContextMenuItemExample: View {
  struct Item: Identifiable {
    let id = UUID()
    var name: String
  }
  var items: [Item]

  @State private var selection = Set<Item.ID>()


  var body: some View {
    NavigationStack {
      List(selection: $selection) {
        ForEach(items) { item in
          HStack {
            Image(systemName: "clock")
            Text(item.name)
          }
          .frame(height: 80)
        }
      }
      .toolbar {
        EditButton()
      }
    }
    .contextMenu(forSelectionType: Item.ID.self) { items in
      if items.isEmpty { // Empty area menu.
        Button("New Item") { }


      } else if items.count == 1 { // Single item menu.
        Button("Copy") { }
        Button("Delete", role: .destructive) { }


      } else { // Multi-item menu.
        Button("Copy") { }
        Button("New Folder With Selection") { }
        Button("Delete Selected", role: .destructive) { }
      }
    }
  }
}
