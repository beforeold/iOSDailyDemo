import SwiftUI

struct ContentView: View {
  @State private var selection = Set<Int>()
  var body: some View {
    Menu {
      let _ = print("menu content")
      Button("Menu 1") {

      }
    } label: {
      Text("Hello")
        .padding()
        .background(Color.blue)
        .onTapGesture {
          print("menu tapped")
        }
    } primaryAction: {
      print("primary")
    }
  }
}

struct ButtonWrapper: UIViewRepresentable {
  func makeUIView(context: Context) -> some UIView {
    let button = UIButton(type: .system)
    button.setTitle("Options", for: .normal)

    // Create a menu
    let menu = UIMenu(title: "", children: [
        UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { action in
            print("Edit tapped")

          // print("alltargets", button.allTargets)
        },
        UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            print("Delete tapped")
        }
    ])

    button.menu = menu
    button.showsMenuAsPrimaryAction = true


    class Coordinator: NSObject {
      static let shared = Coordinator()
      @objc func onTouchDown() {
        print("touch down")
      }
    }




    button.addTarget(
      Coordinator.shared,
      action: #selector(Coordinator.onTouchDown),
      for: .touchDown
    )

    return button
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {

  }
}

#Preview {
  ButtonWrapper()
}
