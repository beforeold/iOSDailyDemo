//
//  ContentView.swift
//  TestSignal
//
//  Created by beforeold on 2024/1/6.
//

import SwiftUI
import Combine

func foo() {
  var disposables: [AnyCancellable] = []
  
  var signal = [1, 2, 3].publisher
  
  let map1Signal = signal.map {
    [$0, $0]
  }
  
  print(
    "map1",
    map1Signal.sink(receiveValue: {
      print("map", $0)
    })
    .store(in: &disposables)
  )
  
  let flatMap1Signal = signal.flatMap {
    [$0, $0].publisher
  }
  
  print(
    "flatMp1",
    flatMap1Signal.sink(receiveValue: {
      print("flat", $0)
    })
    .store(in: &disposables)
  )
}


struct ContentView: View {
  var body: some View {
    let _ = foo()
    
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}
//
//#Preview {
//    ContentView()
//    .preferredColorScheme(\.dark)
//}
