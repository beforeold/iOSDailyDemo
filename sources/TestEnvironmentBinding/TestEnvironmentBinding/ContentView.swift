//
//  ContentView.swift
//  TestEnvironmentBinding
//
//  Created by Brook_Mobius on 1/5/24.
//

import SwiftUI


struct CustomEnvKey: EnvironmentKey {
  @MainActor static var defaultValue: Binding<Bool> {
    .constant(false)
  }
}

extension EnvironmentValues {
  var isCustomLoading: Binding<Bool> {
    get { self[CustomEnvKey.self] }
    set { self[CustomEnvKey.self] = newValue }
  }
}

struct SubView: View {
  @Environment(\.isCustomLoading)
  private var isCustomLoading

  var body: some View {
    Button("tap") {
      Task { @MainActor in
        self.isCustomLoading.wrappedValue = true
        try await Task.sleep(nanoseconds: 2_000_000_000)
        self.isCustomLoading.wrappedValue = false
      }
    }
  }
}


struct ContentView: View {
  @State var isCustomLoading = false

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
      
      SubView()

      if self.isCustomLoading {
        ProgressView()
      }
    }
    .padding()
    .environment(\.isCustomLoading, self.$isCustomLoading)
  }
}

#Preview {
  ContentView()
}
