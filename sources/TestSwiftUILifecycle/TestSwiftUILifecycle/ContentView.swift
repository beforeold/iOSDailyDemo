//
//  ContentView.swift
//  TestSwiftUILifecycle
//
//  Created by Brook_Mobius on 3/23/24.
//

import SwiftUI

class MyLabel: UILabel {
  var label: UILabel!
  var button: UIButton!

  var action: () -> Void = { }

  override init(frame: CGRect) {
    super.init(frame: frame)

    label = UILabel(frame: .init(x: 0, y: 0, width: 150, height: 100))
    label.textColor = .yellow
    addSubview(label)

    button = UIButton(type: .custom)
    button.setTitle("Click", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.frame = .init(x: 200, y: 0, width: 150, height: 100)
    button.addTarget(self, action: #selector(onActionEvent), for: .touchUpInside)
    addSubview(button)

    backgroundColor = .lightGray.withAlphaComponent(0.2)
    isUserInteractionEnabled = true
  }

  @objc private func onActionEvent() {
    action()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("deinit mylabel")
  }
}

struct SubView: UIViewRepresentable {
  typealias UIViewType = MyLabel

  var value: String

  @State private var privateValue = 0

  class Coordinator {
    var binding: Binding<Int> = .constant(0)

    @objc func onAction() {
      print("onaction coordinator")
      binding.wrappedValue += 1
    }
  }

  func makeCoordinator() -> Coordinator {
    let coor = Coordinator()
    coor.binding = $privateValue
    return coor
  }

  func makeUIView(context: Context) -> MyLabel {
    let label = MyLabel()
    label.action = {
      context.coordinator.onAction()
    }
    print("init mylabel")

    return label
  }

  func updateUIView(_ uiView: MyLabel, context: Context) {
    let text = "\(value), \(privateValue)"
    uiView.label.text = text
    print("updateui: \(text)")
  }

//  var body: some View {
//    let _ = Self._printChanges()
//
//    Text(value)
//      .onAppear {
//        print("sub appear \(value)")
//      }
////      .id(value)
//  }
}

struct ContentView: View {
  @State var count = 0

  @State var flag = true

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Group {
        if flag {
          SubView(value: "label: \(count)")
        } else {
          Text("text")
        }
      }
      .frame(height: 100)

      Button("plus count") {
        self.count += 1
      }

      Toggle(isOn: $flag) {
        Text("toggle")
      }
    }
      .padding()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
