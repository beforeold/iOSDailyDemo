//
//  ContentView.swift
//  DemoMenuTrigger
//
//  Created by beforeold on 2026/1/15.
//

import SwiftUI

struct WrappedUIButton: UIViewRepresentable {
    let title: String
    let menuOptions: [String]
    let onSelection: (String) -> Void

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = buildMenu(options: menuOptions)
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.setTitle(title, for: .normal)
        uiView.menu = buildMenu(options: menuOptions)

        if !context.coordinator.didTriggerMenu {
            context.coordinator.didTriggerMenu = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("trigger menu")
                uiView.performPrimaryAction()
            }
        }
    }

    private func buildMenu(options: [String]) -> UIMenu {
        let actions = options.map { option in
            UIAction(title: option) { _ in
                onSelection(option)
            }
        }
        return UIMenu(title: "", children: actions)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var didTriggerMenu = false
    }
}

struct ContentView: View {
    @State private var menuOptions: [String] = [
      "Option \(Int.random(in: 1...99))",
      "Option \(Int.random(in: 100...199))"
  ]

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            WrappedUIButton(title: "Tap Me", menuOptions: menuOptions) { selection in
                print("Selected: \(selection)")
            }
            .frame(height: 80)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
