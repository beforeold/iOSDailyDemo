//
//  RollView.swift
//  EggFighter
//
//  Created by Brook_Mobius on 7/6/25.
//

import SwiftUI

struct RollView: View {

  @State var value = 0
  @State var disabled = false

  var name: String = ""
  var completion: (Int) -> Void = { _ in }
  var body: some View {
    VStack {
      Text("\(name): \(value)")

      Button("随机一个数字") {
        Task {
          disabled = true

          value = 0
          for _ in 0..<10 {
            try await Task.sleep(for: .milliseconds(200))
            value = (0...100).randomElement()!
          }
          completion(value)
        }
      }
      .buttonStyle(.borderedProminent)
      .disabled(disabled)
    }
  }
}

#Preview {
  RollView(name: "Apple")
}
