//
//  ContentView.swift
//  TestCustomAppStorage
//
//  Created by Brook_Mobius on 5/24/23.
//

import SwiftUI

import SwiftUI

@propertyWrapper
struct AppStorage<Value>: DynamicProperty {
    @State private var storedValue: Value
    private let key: String
    
    var wrappedValue: Value {
        get {
            storedValue
        }
        nonmutating set {
            storedValue = newValue
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(wrappedValue defaultValue: Value, _ key: String) {
        self._storedValue = State(initialValue: UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue)
        self.key = key
        UserDefaults.standard.register(defaults: [key: defaultValue])
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

class ViewModel: ObservableObject {
  
}

struct ContentView: View {
    var body: some View {
        VStack {
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
