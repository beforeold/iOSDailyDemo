import SwiftUI
import UIKit

struct FullScreenView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    VStack {
      Text("全屏视图")
        .font(.largeTitle)
        .padding()
      
      Button("关闭") {
        isPresented = false
      }
      .buttonStyle(.borderedProminent)
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
    .onAppear {
      OrientationManager.shared.isFullScreenPresented = true
    }
    .onDisappear {
      OrientationManager.shared.isFullScreenPresented = false
    }
  }
}

struct ContentView: View {
  @State private var isPresented = false

  var body: some View {
    let _ = Self._printChanges()

    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)

      Text("Hello, world!")
      
      Button("展示全屏视图") {
        isPresented = true
      }
      .buttonStyle(.borderedProminent)
      .padding()
    }
    .padding()
    .fullScreenCover(isPresented: $isPresented) {
      FullScreenView(isPresented: $isPresented)
    }
  }
}

#Preview {
  ContentView()
}
