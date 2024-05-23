//
//  ContentView.swift
//  TestSwiftUIConditionalOS
//
//  Created by xipingping on 5/23/24.
//

import SwiftUI


struct ViewHelper {
  @ViewBuilder
  static func bpContextMenu<S: View, Menu: View, Preview: View>(
    s: S,
    @ViewBuilder menuItems: () -> Menu,
    @ViewBuilder preview: () -> Preview
  ) -> some View {
    if #available(iOS 16.0, *) {
      s.contextMenu(menuItems: menuItems, preview: preview)
    } else {
      s.contextMenu(menuItems: menuItems)
    }
  }
}

extension View {
  // a backport api for context menu method: contextMenu:preview: of swiftui view
  @ViewBuilder
  func bpContextMenu<Menu: View, Preview: View>(
    @ViewBuilder menuItems: () -> Menu,
    @ViewBuilder preview: () -> Preview
  ) -> some View {
    if #available(iOS 16.0, *) {
      self.contextMenu(menuItems: menuItems, preview: preview)
    } else {
      self.contextMenu(menuItems: menuItems)
    }
  }

  func highlights() -> some View {
    self
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .bpContextMenu(
      menuItems: { Text("menu") },
      preview: { Text("preview") }
    )
    .highlights()
    .padding()
  }

  @ViewBuilder
  var nobody: some View {
    ViewHelper.bpContextMenu(
      s: Text(""),
      menuItems: { },
      preview: { }
    )
  }
}

#Preview {
  ContentView()
}
