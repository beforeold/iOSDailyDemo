//
//  ContentView.swift
//  TestSwiftUIPreviewTraits
//
//  Created by beforeold on 6/13/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
//      Toggle(isOn: .constant(true)) {
//        Text("toggle")
//      }
      
      Text("hello world")
    }
    .padding()
//    .frame(maxWidth: .infinity)
    .background(.blue)
  }
}

//struct Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//      .previewLayout(.fixed(width: 200, height: 200))
////      .previewLayout(.sizeThatFits)
////      .previewLayout(.sizeThatFits)
//  }
//}


#Preview {
  ContentView()
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
  ContentView()
}

@available(iOS 17.0, *)
#Preview("sizeThatFitsLayout", traits: .sizeThatFitsLayout) {
  ContentView()
}
