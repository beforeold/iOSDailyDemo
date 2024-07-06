//
//  ContentView.swift
//  TextContextMenuSelection
//
//  Created by beforeold on 7/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      ContextMenuItemExample()
    }
}

#Preview {
    ContentView()
}

struct ContextMenuItemExample: View {
    var items: [Item]
    @State private var selection = Set<Item.ID>()


    var body: some View {
        List(selection: $selection) {
            ForEach(items) { item in
                Text(item.name)
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
