//
//  ContentView.swift
//  TestSwiftUIAlert
//
//  Created by Brook_Mobius on 8/21/23.
//

import SwiftUI

class ViewModel: ObservableObject {
  @Published var flag1 = false
  
  @Published var flag2 = false
}

struct ContentView: View {
  @StateObject var viewModel: ViewModel = .init()
  
  var body: some View {
    VStack(spacing: 20) {
      Button("Flag1") {
        viewModel.flag1 = true
      }

      Button("Flag2") {
        viewModel.flag2 = true
      }
    }
    // < 15.0, only the flag2 works
    .alert(isPresented: $viewModel.flag1) {
      Alert(
        title: Text("Alert1"),
        dismissButton: .cancel()
      )
    }
    .alert(isPresented: $viewModel.flag2) {
      Alert(
        title: Text("Alert2"),
        dismissButton: .cancel()
      )
    }
    /*
     // ios 15.0 +
    .alert("Title Alert1", isPresented: $viewModel.flag1, actions: {
      Button("OK1") {

      }
    })
    .alert("Title Alert2", isPresented: $viewModel.flag2, actions: {
      Button("OK2") {

      }
    })
    */
    .padding()
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .preferredColorScheme(.dark)
  }
}
