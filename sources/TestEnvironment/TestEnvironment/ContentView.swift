//
//  ContentView.swift
//  TestEnvironment
//
//  Created by Brook_Mobius on 11/9/23.
//

import SwiftUI
import Observation

//
//extension EnvironmentValues {
//  public var obs: T
//}

//struct StoreKey<Store>: EnvironmentKey {
//  static var defaultValue {
//
//  }
//}
//
//extension EnvironmentValues {
//    var store: Store {
//        get { self[StoreKey.self] }
//        set { self[StoreKey.self] = newValue }
//    }
//}


//extension Environment {
//  init<T>(
//    type: T.Type
//  ) where T: AnyObject, T: Observable {
//    self.ini
//  }
//}

extension View {
  func myEnv<T>(
    _ object: T
  ) -> some View where T: AnyObject, T: Observable {
    Text("12")
  }
}

struct ObsKey<T>: EnvironmentKey {
  static var defaultValue: T {
    fatalError("no environment for \(T.self)")
  }

  typealias Value = T
}

struct ContentView: View {
  @MyEnvironment var myAge: Int

  var body: some View {
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
//  ContentView()
//}
