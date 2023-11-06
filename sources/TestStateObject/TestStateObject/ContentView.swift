//
//  ContentView.swift
//  TestStateObject
//
//  Created by beforeold on 2023/11/6.
//

import SwiftUI

class InnerViewModel: ObservableObject {
  @Published var name: String = "brook"
  
  init(name: String) {
    self.name = name
    print("init viewmodel", name)
  }
}

struct InnerView: View {
  @StateObject var viewModel: InnerViewModel
  
//  init(viewModel: InnerViewModel) {
//    self._viewModel = StateObject(wrappedValue: viewModel)
//    
//    print("init view", viewModel.name)
//  }
  
  init(name: String) {
    print("initview", name)
    _viewModel = StateObject(wrappedValue: InnerViewModel(name: name))
  }
  
  var body: some View {
    Text("name: \(viewModel.name)")
  }
}

struct ContentView: View {
  @State var count = 0
  var body: some View {
    VStack {
      let _ = print("current: \(count)")
      // InnerView(viewModel: .init(name: "\(count)"))
      InnerView(name: "\(count)")
      
      Text("count: \(count)")
      
      Button("Plus count") {
        count += 1
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
