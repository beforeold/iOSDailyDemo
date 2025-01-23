import ObservationBP
import SwiftUI

struct ContentView: ViewBP {
  @State private var object = NSObject()
  @State private var isLoading = true
  @State private var showsScrollView = true

  var bodyBP: some View {
    NavigationView {
      VStack(spacing: 30) {
        Button("reset") {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showsScrollView.toggle()
          }
        }

        NavigationLink("Push") {
          Text("Detail")
        }

        if showsScrollView {
          ScrollView {
            VStack {
              Text("Hello")
                .frame(height: 300)
                .background(footer)
            }
          }
        } else {
          Text("No ScrollView")
        }

        Spacer()
      }
      .padding()
    }
  }

  var footer: some View {
    GeometryReader { [weak object] geo in
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        if object == nil {
//          print("dismiss")
//          return
//        }
//
//        guard showsScrollView else {
//          print("empty")
//          return
//        }

        let minY = geo.frame(in: .global).minY
        print("delay", "frame: \(Int(minY))", "isLoading: \(isLoading)")
        isLoading = false
      }

      return Color.clear
    }
  }

}

#Preview {
  ContentView()
}
