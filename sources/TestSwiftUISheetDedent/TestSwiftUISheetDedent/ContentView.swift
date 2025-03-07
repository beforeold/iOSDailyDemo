import SwiftUI

struct ContentView: View {
  @State private var height: CGFloat = 0

  @State private var isPresented = false

  var body: some View {
    VStack {
      Button("Show") {
        isPresented = true
      }
    }
    .sheet(isPresented: $isPresented) {
      ScrollView {
        VStack {
          Text("t1")

          Text("t2")
            .frame(width: UIScreen.main.bounds.width, height: 600)
        }
        .background {
          GeometryReader { reader in
            height = reader.frame(in: .local).size.height

            return Color.clear
          }
        }
      }
      .presentationDetents([.height(height)])
      .onAppear {
        print("onappear")
      }
    }
  }
}

#Preview {
  ContentView()
}
