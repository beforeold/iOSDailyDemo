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

struct TestForEachView: ViewBP {
  let model = ForEeachModel()

  var bodyBP: some View {
    let _ = Self._printChanges()

    VStack(spacing: 30) {
      ForEach(model.titles, id: \.self) { title in
        ObservationView {
          HStack {
            Text(title)

            Spacer()

            if model.selectedTitle == title {
              Text("isSelected")
            } else {
              let _ = print("selectedTitle", model.selectedTitle ?? "null", title)
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            print("tap", title)
            model.selectedTitle = title
          }
        }
      }
    }
    .padding()
  }
}

#Preview {
  TestForEachView()
}
