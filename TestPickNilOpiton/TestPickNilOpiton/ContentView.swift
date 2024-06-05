//
//  ContentView.swift
//  TestPickNilOpiton
//
//  Created by beforeold on 6/5/24.
//

import SwiftUI

class ViewModel: ObservableObject {
  enum Option: String {
    case one
    case two
    
    static var all: [Option?] {
      return [.one, .two, nil]
    }
  }
  
  @Published var option: Option? = nil {
    didSet {
      print("selected option", option?.rawValue ?? "Unset")
    }
  }
}

struct ContentView: View {
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    Form {
      Picker("Option", selection: self.$viewModel.option) {
        ForEach(ViewModel.Option.all, id: \.self) { option in
          Text(option?.rawValue ?? "Unset")
            .tag(option)
        }
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
