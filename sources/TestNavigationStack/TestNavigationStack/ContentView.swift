//
//  ContentView.swift
//  TestNavigationStack
//
//  Created by beforeold on 4/29/24.
//

import SwiftUI

enum HeaderTag {
  case header
}

struct HeaderView: View {
  var body: some View {
    NavigationLink(value: HeaderTag.header) {
      Text("hello")
    }
  }
}

struct RowItem {
  var index: Int
}

struct ListView: View {
  var body: some View {
    ScrollView {
      ForEach(
        self.items,
        id: \.index
      ) { item in
        let index = item.index
        NavigationLink(value: index) {
          Text("row item \(index)")
            .frame(height: 80)
        }
      }
    }
  }
  
  var items: [RowItem] {
    (0..<100).map(RowItem.init)
  }
}

struct ContentView: View {
  var body: some View {
    NavigationStack {
      self.rootView
    }
  }
  
  @ViewBuilder
  private var rootView: some View {
    VStack {
      HeaderView()
      
      ListView()
    }
    .navigationDestination(for: Int.self) { index in
      Text("dest of row \(index)")
    }
    .navigationDestination(for: HeaderTag.self) { _ in
      Text("dest of header")
    }
  }
}

#Preview {
  ContentView()
    .tint(.white)
    .preferredColorScheme(.dark)
}
