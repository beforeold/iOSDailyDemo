import SwiftUI

struct Card<Content: View>: View {
  @ViewBuilder var content: Content
  
  var body: some View {
    HStack {
      ForEach(subviews: content) { sub in
        sub
      }
    }
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      
      
      Card {
        Text("Hello, world!")
        
        Text("Hello, world!")
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
