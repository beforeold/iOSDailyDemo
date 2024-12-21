//
//  main.swift
//  TestDateStyle
//
//  Created by Brook_Mobius on 12/21/24.
//

import Foundation

let date = Date()
let formatter = DateFormatter()

do {
  // December 21, 2024
  formatter.dateStyle = .long
  let string = formatter.string(from: date)
  print(string)

}
do {
  // Dec 21, 2024
  formatter.dateStyle = .medium
  let string = formatter.string(from: date)
  print(string)
}

do {
  // 12/21/24
  formatter.dateStyle = .short
  let string = formatter.string(from: date)
  print(string)
}

do {
  // Saturday, December 21, 2024
  formatter.dateStyle = .full
  let string = formatter.string(from: date)
  print(string)
}

do {
  // (empty string)
  formatter.dateStyle = .none
  let string = formatter.string(from: date)
  print(string)
}
