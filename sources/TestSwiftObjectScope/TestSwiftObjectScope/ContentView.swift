//
//  ContentView.swift
//  TestSwiftObjectScope
//
//  Created by beforeold on 5/12/24.
//

import SwiftUI

class Model: NSObject {
  var age: Int
  
  init(age: Int) {
    self.age = age
  }
}

func withScope<T>(_ builder: () -> T) -> T {
  builder()
}

struct Scope<V> {
  var builder: () -> V
  
  func callAsFunction() -> V {
    builder()
  }
}

extension Scope where V == Never {
  static func build<T>(_ builder: () -> T) -> T {
    builder()
  }
}

extension Int {
  func build<T>(_ builder: () -> T) -> T {
    builder()
  }
}

struct ContentView: View {
  var model: Model
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

#Preview {
  ContentView(
    model: .init(age: 5)
  )
}

#Preview {
  ContentView(model: {
    let model = Model(age: 5)
    return model
  }())
}

// ✅
#Preview {
  ContentView(
    model: Scope.build {
      let model = Model(age: 5)
      return model
    }
  )
}

#Preview {
  ContentView(
    model: Scope.build({
      let model = Model(age: 5)
      return model
    })
  )
}

#Preview {
  ContentView(
    model: 5.build({
      let model = Model(age: 5)
      return model
    })
  )
}

#Preview {
  ContentView(
    model: withScope({
      let model = Model(age: 5)
      return model
    })
  )
}

#Preview {
  ContentView(
    model: Scope {
      let model = Model(age: 5)
      return model
    }.builder()
  )
}

#Preview {
  ContentView(
    model: Scope {
      let model = Model(age: 5)
      return model
    }()
  )
}
