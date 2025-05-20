//
//  ContentView.swift
//  TestSystemFont18_4
//
//  Created by Brook_Mobius on 5/16/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TestView()
      .environment(\.font, Font(uifont))
  }

  private var uifont: UIFont {
    let font = UIFont.systemFont(ofSize: 14)
    print(font)
    return font
  }
}

struct TestView: View {
  @Environment(\.font)
  private var font

  var body: some View {
    VStack {
      Text("令牌「OK」\(UIDevice.current.systemVersion)")

      Text("\(font.debugDescription)")
    }
    .padding()
  }
}

#Preview("English") {
  ContentView()
    .environment(\.locale, .init(identifier: "en"))
    .font(.title)
}

#Preview("中文") {
  ContentView()
    .environment(\.locale, .init(identifier: "zh-Hans"))
    .font(.title)
}
