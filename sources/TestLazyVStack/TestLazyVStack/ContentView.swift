//
//  ContentView.swift
//  TestLazyVStack
//
//  Created by xipingping on 4/24/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading) {

        manualBuild()

      }
    }
    .padding()
  }

  @ViewBuilder
  private func forEachBuild() -> some View {
    ForEach(0...100, id: \.self) { value in
      Text("Row \(value)")
        .frame(height: 200)
        .onAppear {
          print("appear", value)
        }
        .onDisappear {
          print("disappear", value)
        }
    }
  }

  @ViewBuilder
  private func manualBuild() -> some View {
    var value = 0

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)

    makeText(&value)
  }

  @ViewBuilder
  private func makeText(_ value: inout Int) -> some View {
    let _ = { value += 1 }()

    Text("Row \(value)")
      .frame(height: 200)
      .onAppear { [value] in
        print("appear", value)
      }
      .onDisappear { [value] in
        print("disappear", value)
      }
  }
}

#Preview {
  ContentView()
}
