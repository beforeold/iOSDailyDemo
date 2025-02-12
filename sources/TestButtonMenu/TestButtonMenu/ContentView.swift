import SwiftUI

//struct ContentView: View {
//  var body: some View {
//    Button(action: {
//      // Button action here
//      print("Button tapped")
//    }) {
//      Text("Tap Me")
//        .padding()
//        .background(Color.blue)
//        .foregroundColor(.white)
//        .cornerRadius(10)
//    }
//    .contextMenu {
//      Button(action: {
//        // Action for first option
//        print("First Option Selected")
//      }) {
//        Text("First Option")
//        Image(systemName: "star.fill")
//      }
//
//      Button(action: {
//        // Action for second option
//        print("Second Option Selected")
//      }) {
//        Text("Second Option")
//        Image(systemName: "heart.fill")
//      }
//    }
//  }
//}

struct ContentView: View {
  var body: some View {
    Menu {
      // Menu items
      Button(action: {
        print("Copy option selected")
      }) {
        Label("Copy", systemImage: "doc.on.doc")
      }

      Button(action: {
        print("Share option selected")
      }) {
        Label("Share", systemImage: "square.and.arrow.up")
      }
      .disabled(true)

      Button(action: {
        print("Delete option selected")
      }) {
        Label("Delete", systemImage: "trash")
      }

      Button("Open in Preview", action: {})

    } label: {
      // Button that triggers the menu
      Text("Tap for Menu")
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    .menuStyle(.borderlessButton)
  }
}

#Preview {
  ContentView()
}
