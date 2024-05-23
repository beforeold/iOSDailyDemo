//
//  ContentView.swift
//  HWSSelfProject1
//
//  Created by beforeold on 2024/1/13.
//

import SwiftUI

struct ContentView: View {
  let units = [
    "mm",
    "m",
    "km"
  ]
  
  @State private var inputUnit = "m"
  @State private var inputValue = 0.0
  @State private var ouputUnit = "km"
  
  private var outputValue: Double {
    let input = self.inputValue * self.factor(for: self.inputUnit)
    let output = input / self.factor(for: self.ouputUnit)
    return output
  }
  
  private func factor(for unit: String) -> Double {
    switch unit {
    case "mm":
      return 0.001
    case "m":
      return 1
    case "km":
      return 1000
    default:
      fatalError("unexpected unit \(unit)")
    }
  }
  
  var body: some View {
    NavigationStack {
      Form {
        Section("Input Unit") {
          Picker("Input Unit", selection: self.$inputUnit) {
            ForEach(self.units, id: \.self) {
              Text($0)
            }
          }
          .pickerStyle(.segmented)
        }
        
        Section("Output Unit") {
          Picker("Output Unit", selection: self.$ouputUnit) {
            ForEach(self.units, id: \.self) {
              Text($0)
            }
          }
          .pickerStyle(.segmented)
        }
        
        Section("Input Value") {
          TextField(
            "Input Value",
            value: self.$inputValue,
            format: .number
          )
        }
        
        Section("Output Value") {
          Text(self.outputValue, format: .number)
        }
      }
    }
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
