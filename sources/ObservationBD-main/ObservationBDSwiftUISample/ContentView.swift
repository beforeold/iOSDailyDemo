//
//  ContentView.swift
//  ObservationBDSwiftUISample
//
//  Created by Dmitry Galimzyanov on 03.07.2023.
//

import ObservationBD
import SwiftUI

@ObservableBD
final class ContentViewModel {
  var counter = 0
  var age: Double = 0
}

struct ContentView: View {
  var model: ContentViewModel
  
  var body: some View {
    VStack {
      OtherContentView(model: model)
      
      Divider()
      
      AgeContentView(model: model)
    }
    .padding()
  }
}

struct OtherContentView: ObserableView {
  let model: ContentViewModel
  
  var observerableBody: some View {
    let _ = print("counter body")
   
    Text("Counter: \(model.counter)")
    
    Button {
      model.counter += 1
    } label: {
      Text("Increment")
    }
  }
}

struct AgeContentView: ObserableView {
  let model: ContentViewModel
  
  var observerableBody: some View {
    let _ = print("age body")
   
    Text("age: \(model.age)")
    
    Button {
      model.age += 1
    } label: {
      Text("Increment")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(model: ContentViewModel())
  }
}
