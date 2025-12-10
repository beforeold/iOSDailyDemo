import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")
      }
      .padding()
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Text("hello")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .fixedSize()
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button {

          } label: {
            Image(systemName: "gear")
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button {

          } label: {
            Image(systemName: "gear")
          }
        }


        ToolbarItem(placement: .topBarTrailing) {
          Button {

          } label: {
            Image(systemName: "gear")
          }
        }


//        Button {
//
//        } label: {
//          Image(systemName: "gear")
//        }

//        Button {
//
//        } label: {
//          Image(systemName: "gear")
//        }
      }
    }
  }
}

#Preview {
  ContentView()
}
