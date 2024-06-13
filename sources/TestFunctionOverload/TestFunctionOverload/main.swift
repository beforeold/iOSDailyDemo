//
//  main.swift
//  TestFunctionOverload
//
//  Created by xipingping on 6/13/24.
//

import Foundation

// a product struct
struct Product {
  var name: String
  var price: Double
}

extension Product: Decodable {
  enum CodingKeys: String, CodingKey {
    case name
    case price
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    price = try container.decode(Double.self, forKey: .price)
  }
}

// fetch products from web api
func fetchProducts() async throws -> [Product] {
  // call URLSession to request products
  let (data, _) = try await URLSession.shared.data(from: URL(string: "https://example.com/products")!)

  // decode the products
  return try JSONDecoder().decode([Product].self, from: data)
}

func foo() -> Int {
  5
}

func foo() -> String {
  "foo"
}

let int: Int = foo()
print(int)

let string: String = foo()
print(string)

