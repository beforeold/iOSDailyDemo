//
//  Item.swift
//  TsetWithEvents
//
//  Created by xipingping on 7/15/24.
//

import Foundation
import SwiftData

@Model
final class Item {
  var timestamp: Date

  init(timestamp: Date) {
    self.timestamp = timestamp
  }
}
