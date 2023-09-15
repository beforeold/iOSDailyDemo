//
//  DataLoader.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/14/23.
//

import Foundation


struct DataLoader {
  struct Item: Codable {
    var id: String
    var url: String
    var status: Int
  }

  enum ContextError: Error {
    case unknown(Error)
    case noDataFile
    case failToLoad(Error)
  }

  static func load() async throws -> [Item] {
    guard let url  = Bundle.main.url(
      forResource: "check",
      withExtension: "json"
    ) else {
      throw ContextError.noDataFile
    }

    do {
      let data = try Data(contentsOf: url)
      let items = try JSONDecoder().decode([Item].self, from: data)
      debugPrint(#function, "loadItems", items.count)
      return items

    } catch {
      throw ContextError.failToLoad(error)
    }

  }
}
