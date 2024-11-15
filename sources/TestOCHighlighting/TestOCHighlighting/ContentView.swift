import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      MyObject().foo()
      MyPerson().foo()
      print("appear")

      MyPerson().call {
        debugPrint("call block")


        let p1 = MyPerson()
        let p2 = MyPerson()

        print(p1)
        print(p2)

        print("")


        print(MyPerson())
        print(MyPerson())

        print(MyPerson() === MyPerson())
      }
    }
  }
}

#Preview {
  ContentView()
}
