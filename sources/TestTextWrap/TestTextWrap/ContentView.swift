//
//  ContentView.swift
//  TestTextWrap
//
//  Created by beforeold on 2023/10/19.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    var attributedString = AttributedString("This is a string with empty attributes.")
    var container = AttributeContainer()
    container[AttributeScopes.UIKitAttributes.ForegroundColorAttribute.self] = .white
    container[AttributeScopes.UIKitAttributes.BackgroundColorAttribute.self] = .gray
    attributedString.mergeAttributes(container, mergePolicy: .keepNew)
    
    return Text(attributedString)
      .padding()
  }
  
  
}

func yourBoolFunction(_ value: Any) -> Bool {
  return true
}

struct RichText {
  
  
  func toStyleText() -> Text {
    // 不考虑前景色后景色的代码
    return Text("fancy text")
  }
  
  @ViewBuilder func withColorText() -> some View {
    if yourBoolFunction("test") {
      toStyleText().foregroundColor(Color.blue)
    } else {
      toStyleText().background(Color.green)
    }
  }
  
  func foo() {
    Text(AttributedString("hello"))
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
