//
//  TestForEachView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by Brook_Mobius on 11/19/23.
//

import SwiftUI
import ObservationBP

@Observable
class ForEeachModel {
  var titles: [String] = [
    "first",
    "second",
    "third",
  ]

  var selectedTitle: String? = nil
}

struct TestForEachView: View {
  let model = ForEeachModel()

  var body: some View {
    VStack {
      ForEach(model.titles, id: \.self) { title in
        HStack {
          Text(title)
          if model.selectedTitle == title {
            Text("isSelected")
          }
        }
      }
    }
  }
}

#Preview {
  TestForEachView()
}
