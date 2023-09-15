//
//  DataLoader.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/14/23.
//

import Foundation

struct DataLoader {


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

extension DataLoader {
  struct Item: Codable {
    var id: String
    var url: String
    var status: Int

    /// 保存结果时使用
    var isFace: Bool?

    static let mock = Item(
      id: "qrouq",
      url: "https://d1yrhypp3nh74k.cloudfront.net/p/39f2c823c07388d3363f8248a07947ae.webp",
      status: 0
    )
  }
}
