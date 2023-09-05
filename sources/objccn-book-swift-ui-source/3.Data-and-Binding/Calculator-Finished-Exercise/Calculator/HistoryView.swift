//
//  HistoryView.swift
//  Calculator
//
//  Created by beforeold on 2023/9/5.
//  Copyright © 2023 OneV's Den. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
  @Environment(\.dismiss) var dismiss
  
  @ObservedObject var model: CalculatorModel
  @Binding var editingHistory: Bool
  
  var body: some View {
    let _ = print(#function, "History")
    VStack(spacing: 20) {
      HStack {
        Button("Close") {
          editingHistory = false
        }
        
        Spacer()
        
        Button("Dismiss") {
          dismiss()
        }
      }
      .padding()
      
      if model.totalCount == 0 {
        Text("没有履历")
      } else {
        HStack {
          Text("履历").font(.headline)
          Text("\(model.historyDetail)").lineLimit(nil)
        }
        HStack {
          Text("显示").font(.headline)
          Text("\(model.brain.output)")
        }
        Slider(value: $model.slidingIndex, in: 0...Float(model.totalCount), step: 1)
      }
    }.padding()
  }
}

