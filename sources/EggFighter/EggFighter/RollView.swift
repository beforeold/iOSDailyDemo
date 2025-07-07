//
//  RollView.swift
//  EggFighter
//
//  Created by Brook_Mobius on 7/6/25.
//

import SwiftUI

struct RollView: View {

  @State var value: Int? = nil
  @State var offset = 0
  @State var disabled = false

  var name: String = ""
  var completion: (Int) -> Void = { _ in }
  var body: some View {
    VStack(spacing: 32) {
      Text("\(name): \(valueString)")
        .font(.title2)

      Button("随机一个数字 0 - 100") {
        Task {
          disabled = true

          offset = 0
          value = 0
          for offset in 0..<10 {
            try await Task.sleep(for: .milliseconds(200))
            self.offset = offset
            value = (0...100).randomElement()!
          }
          completion(value ?? 0)
        }
      }
      .buttonStyle(.borderedProminent)
      .disabled(disabled)
    }
  }

  private var valueString: String {
    if offset == 9 {
      return "??"
    }
    if let value {
      return value.description
    }
    return "--"
  }
}

#Preview {
  RollView(name: "Apple")
}
