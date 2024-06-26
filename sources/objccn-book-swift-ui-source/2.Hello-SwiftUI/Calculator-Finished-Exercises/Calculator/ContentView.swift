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
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        Spacer()
        Text("0")
          .font(.system(size: 76))
          .minimumScaleFactor(0.5)
          .padding(.trailing, 24 * scale)
      }
      CalculatorButtonPad()
        .padding(.bottom)
    }
    .frame(minHeight: 0, maxHeight: .infinity, alignment: .bottom)
  }
}

struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
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
      if size.width > size.height {
        old
      } else {
        new
      }
    }
  }
  
  var old: some View {
    Text(title)
      .font(.system(size: fontSize * scale))
      .foregroundColor(foregroundColor)
      .frame(width: size.width * scale, height: size.height * scale)
      .background(Color(backgroundColorName))
      .cornerRadius(size.width * scale / 2)
  }
  
  var new: some View {
    ZStack {
      Circle()
        .fill(Color(backgroundColorName))
      Text(title)
        .font(.system(size: fontSize * scale))
        .foregroundColor(foregroundColor)
    }
    .frame(width: size.width * scale, height: size.height * scale)
  }
}

struct CalculatorButtonRow : View {
  let row: [CalculatorButtonItem]
  var body: some View {
    HStack {
      ForEach(row, id: \.self) { item in
        CalculatorButton(
          title: item.title,
          size: item.size,
          backgroundColorName: item.backgroundColorName,
          foregroundColor: item.foregroundColor)
        {
          print("Button: \(item.title)")
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
