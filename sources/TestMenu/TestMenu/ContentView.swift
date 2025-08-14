import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(spacing: 30) {
      BodyView()

      ButtonWrapper()
        .frame(width: 100, height: 100)
    }
  }
}

struct BodyView: View {
  @State private var selection = Set<Int>()
  var body: some View {
    Menu {
      let _ = print("menu content")
      Button {
        print("menu 1")
      } label: {
        Label {
          Text("Menu 1")
        } icon: {
          Image(systemName: "pencil")
        }
      }
      .onAppear {
        print("item appear")
      }
    } label: {
      HStack {
        Text("Hello")
          .padding()
          .onTapGesture {
            print("menu tapped")
          }

        Image(systemName: "circle")
      }
    }
    .menuStyle(.button)
  }
}

struct ButtonWrapper: UIViewRepresentable {
  func makeUIView(context: Context) -> some UIView {
    let button = UIButton(type: .system)
    button.setTitle("Options", for: .normal)

    // Create a menu
    let menu = UIMenu(
      title: "",
      children: [
        UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { action in
          print("Edit tapped")

          // print("alltargets", button.allTargets)
        },
        UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
          print("Delete tapped")
        },
      ]
    )

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
  VStack(spacing: 30) {
    ContentView()

    ButtonWrapper()
  }
}
