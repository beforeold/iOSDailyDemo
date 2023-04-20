//
//  ContentView.swift
//  TesSwiftUIDynamicLookup
//
//  Created by beforeold on 21/04/23.
//

import SwiftUI

class ViewModel: ObservableObject {
  @Published var string = ""
  
  var value: Double = 0 {
    didSet {
      string = "string: \(value)"
    }
  }
  
  var valueString: String {
    return "value \(value)"
  }
}

struct ContentView: View {
  @StateObject var viewModel: ViewModel
  
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Slider(value: $viewModel.value, in: 0...1)
      Text(viewModel.valueString)
      Text(viewModel.string)
      
      Button {
        viewModel.value += 0.1
      } label: {
        Text("plus 0.1")
      }

    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewModel: .init())
  }
}
