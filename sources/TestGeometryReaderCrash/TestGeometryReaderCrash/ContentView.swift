import SwiftUI

struct ContentView: View {
  @State private var id = 0

  var body: some View {
    NavigationView {
      VStack {
        Button("reset") {
          id += 1
        }

        NavigationLink("Push") {
          Text("Detail")
        }

        SubView()
          .frame(width: 100, height: 100)
          .background(.gray.opacity(0.3))
          .id(id)

        Spacer()
      }
      .padding()
    }
  }
}

struct SubView: View {
  @State private var isLoading = true

  var body: some View {
    GeometryReader { geo in
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        let frame = geo.frame(in: .global).minY
        print("delay", frame, isLoading)
        isLoading = false
      }

      return VStack(spacing: 30) {
        Group {
          if isLoading {
            ProgressView()
          } else {

          }
        }
        .frame(height: 40)

        Color.blue
      }
    }
  }
}

#Preview {
  ContentView()
}
