//
//  ContentView.swift
//  TestSwiftUIID
//
//  Created by beforeold on 5/12/24.
//

import Observation
import SwiftUI

class Model: NSObject, ObservableObject {
  @Published var age = 0
  
  override init() {
    super.init()
    
    print("model init \(self)")
  }
  
  
  deinit {
    print("deinit \(self)")
  }
  
}

class PlainModel: NSObject {
  
//  override init() {
//    super.init()
//    
//    print("model init \(self)")
//  }
//  
//  deinit {
//    print("deinit \(self)")
//  }
}

@Observable
class ObsModel: NSObject {
  var age = 0
//
//  override init() {
//    super.init()
//    
//    print("model init \(self)")
//  }
//  
//  
//  deinit {
//    print("deinit \(self)")
//  }
}

struct CountView: View {
  @StateObject
  private var model = Model()
  
  @State
  private var obsModel = ObsModel()
  
  @State
  private var plainModel = PlainModel()
  
  let count: Int
  
  var body: some View {
    self.modelBody
    Text("plainmodel: \(self.plainModel)")
    // self.obsModelBody
  }
  
  @ViewBuilder
  private var modelBody: some View {
    Text("count: \(self.count)")
    Text("age: \(self.model.age)")
    
    Text("model: \(self.model)")
    
    Button("plus age") {
      self.model.age += 1
    }
  }
  
  @ViewBuilder
  private var obsModelBody: some View {
    Text("count: \(self.count)")
    Text("age: \(self.obsModel.age)")
    Text("model: \(self.obsModel)")
    
    Button("plus age") {
       self.obsModel.age += 1
    }
  }
}

struct ContentView: View {
  @State private var count = 0
  
  var body: some View {
    VStack(spacing: 20) {
      VStack {
        CountView(count: self.count)
      }
      .padding()
      .border(Color.gray)
      .id(self.count)
      
      Button("plus count") {
        self.count += 1
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
