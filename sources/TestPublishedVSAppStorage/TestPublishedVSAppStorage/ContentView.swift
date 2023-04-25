//
//  ContentView.swift
//  TestPublishedVSAppStorage
//
//  Created by Brook_Mobius on 4/25/23.
//

import SwiftUI

class ViewModel: ObservableObject {
  @Published var publishedFlag = false
  
  @AppStorage("flag") var storedFlag = false
  
}

struct ContentView: View {
  @StateObject var viewModel: ViewModel = .init()
  
  func showValue() {
    let published: Binding<Bool> = $viewModel.publishedFlag
    print(published)
    
    let published2: Published<Bool>.Publisher = viewModel.$publishedFlag
    print(published2)
    
    let stored: Binding<Bool> = $viewModel.storedFlag
    print(stored)
    
    let stored2: Binding<Bool> = viewModel.$storedFlag
    print(stored2)
  }
  
  var body: some View {
    VStack {
      Toggle(isOn: $viewModel.publishedFlag) {
        Text("publishedFlag")
      }
      
      Text("published \(viewModel.publishedFlag.description)")
      
//      Toggle(isOn: $viewModel.storedFlag) {
//        Text("storedFlag")
//      }
      
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
