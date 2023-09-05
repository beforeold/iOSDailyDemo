//
//  ContentView.swift
//  Calculator
//
//  Created by Wang Wei on 2019/06/17.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

let scale = UIScreen.main.bounds.width / 414

struct ContentView : View {
  
  @EnvironmentObject var model: CalculatorModel
  
  @State private var editingHistory = false
  
  @State private var showingResult = false
  
  let showsHisotry = true
  
  var body: some View {
    let _ = print(#function, "ContentView")
    VStack(spacing: 12) {
      Spacer()
      if showsHisotry {
        HistoryView(
          model: self.model,
          editingHistory: $editingHistory
        )
      } else {
        Button("操作履历: \(model.history.count)") {
          self.editingHistory = true
        }.sheet(isPresented: self.$editingHistory) {
          HistoryView(
            model: self.model,
            editingHistory: $editingHistory
          )
        }
      }
      
      
      Text(
        model.brain.output
      )
      .font(.system(size: 76))
      .minimumScaleFactor(0.5)
      .padding(.horizontal, 24 * scale)
      .lineLimit(1)
      .frame(
        minWidth: 0,
        maxWidth: .infinity,
        alignment: .trailing
      )
      .onTapGesture {
        showingResult = true
      }
      
      CalculatorButtonPad()
        .padding(.bottom)
    }
    .alert(
      currentExpression,
      isPresented: $showingResult
    ) {
      Button("Cancel") {
        
      }
      
      Button("Copy") {
        UIPasteboard.general.string = model.brain.output
      }
      
    } message: {
      Text(model.brain.output)
    }
  }
  
  private var currentExpression: String {
    model.historyDetail
  }
}

struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
    }
    .environmentObject(
      CalculatorModel()
    )
    .preferredColorScheme(.dark)
  }
}

struct CalculatorButton : View {
  
  let fontSize: CGFloat = 38
  let title: String
  let size: CGSize
  let backgroundColorName: String
  let foregroundColor: Color
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: fontSize * scale))
        .foregroundColor(foregroundColor)
        .frame(width: size.width * scale, height: size.height * scale)
        .background(Color(backgroundColorName))
        .cornerRadius(size.width * scale / 2)
    }
  }
}

struct CalculatorButtonRow : View {
  let row: [CalculatorButtonItem]
  @EnvironmentObject var model: CalculatorModel
  var body: some View {
    HStack {
      ForEach(row, id: \.self) { item in
        CalculatorButton(
          title: item.title,
          size: item.size,
          backgroundColorName: item.backgroundColorName,
          foregroundColor: item.foregroundColor)
        {
          self.model.apply(item)
        }
      }
    }
  }
}

struct CalculatorButtonPad: View {
  let pad: [[CalculatorButtonItem]] = [
    [.command(.clear), .command(.flip),
     .command(.percent), .op(.divide)],
    [.digit(7), .digit(8), .digit(9), .op(.multiply)],
    [.digit(4), .digit(5), .digit(6), .op(.minus)],
    [.digit(1), .digit(2), .digit(3), .op(.plus)],
    [.digit(0), .dot, .op(.equal)]
  ]
  
  var body: some View {
    VStack(spacing: 8) {
      ForEach(pad, id: \.self) { row in
        CalculatorButtonRow(row: row)
      }
    }
  }
}
