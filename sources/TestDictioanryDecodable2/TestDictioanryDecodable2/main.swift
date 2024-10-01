import Foundation

// 如果自定义类型在字典中作为 key，那么字典的 json 将是数组的样式
// 见 test() 函数的输出
// 如果试图将自定义类型作为 key，那么只能先用 string decode 之后再 compact

enum EnumType: String, Decodable, Encodable {
  case enhance
  case photo
}

struct StructType: RawRepresentable, Hashable, Decodable, Encodable {
  let rawValue: String
}

//
//  let jsonString = #"""
//  {
//    "enhance": 5
//  }
//  """#
//
//
//  let jsonString3 = #"""
//  [{
//    "enhance": 5
//  }]
//  """#
//
//
//  let jsonString2 = #"""
//  {
//    "type": "enhance"
//  }
//  """#
//
//  struct MyStruct: Decodable, RawRepresentable, Hashable {
//    let rawValue: String
//    init(rawValue: RawValue) {
//      self.rawValue = rawValue
//    }
//
//    init(from decoder: any Decoder) throws {
//      let container = try decoder.singleValueContainer()
//      self.rawValue = try container.decode(String.self)
//    }
//  }
//

//  struct Root: Decodable {
//    var enhance: Int
//  }
//
//  struct Root2: Decodable {
//    var type: EnumType
//  }
//
//  struct Root3: Decodable {
//    var type: StructType
//  }
//
//
//  struct Root4: Decodable {
//    var type: MyStruct
//  }
//
//
//  func fuuuu() {
//    let data = jsonString.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode(Dictionary<MyStruct, Int>.self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  //  let data = jsonString3.data(using: .utf8)!
//  //  do {
//  //    let dict = try JSONDecoder().decode([[MyStruct: Int]].self, from: data)
//  //    print(#function, dict)
//  //  } catch {
//  //    print(#function, error)
//  //  }
//  }
//
//  func fuzz() {
//    let data = jsonString.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode(Dictionary<String, Int>.self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  }
//
//  func foo() {
//    let data = jsonString.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode(Dictionary<EnumType, Int>.self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  }
//
//  func bar() {
//    let data = jsonString.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode([StructType: Int].self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  }
//
//  func zee() {
//    let data = jsonString.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode(Root.self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  }
//
//  func zig() {
//    let data = jsonString2.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode([String: StructType].self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  }
//
//  func zag() {
//    let data = jsonString2.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode([String: EnumType].self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  }
//
//  func duu() {
//    let data = jsonString2.data(using: .utf8)!
//    do {
//      let dict = try JSONDecoder().decode(Root2.self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//
//    do {
//      let dict = try JSONDecoder().decode(Root3.self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//
//    do {
//      let dict = try JSONDecoder().decode(Root4.self, from: data)
//      print(#function, dict)
//    } catch {
//      print(#function, error)
//    }
//  }
//
//
//  fuuuu()
//
//  print("\n\n")
//
//  fuzz()
//
//  print("\n\n")
//
//  foo()
//
//  print("\n\n")
//
//  bar()
//
//  print("\n\n")
//
//  zee()
//
//  print("\n\n")
//
//  zig()
//
//  print("\n\n")
//
//  zag()
//
//  print("\n\n")
//
//  duu()
//


func test() {
  do {
    var dict = [EnumType.enhance: 5, EnumType.photo: 8]
    dict[.photo] = nil
    let data = try JSONEncoder().encode(dict)
    print(#function, String(decoding: data, as: UTF8.self))
  } catch {
    print(error)
  }

  do {
    let dict = [StructType(rawValue: "enhance"): 5, StructType(rawValue: "photo"): 8]
    let value = dict[StructType(rawValue: "enhance")]
    print(value ?? -1)
    let data = try JSONEncoder().encode(dict)
    print(#function, String(decoding: data, as: UTF8.self))
  } catch {
    print(error)
  }

  do {
    let dict = ["enhance": 5]
    let data = try JSONEncoder().encode(dict)
    print(#function, String(decoding: data, as: UTF8.self))
  } catch {
    print(error)
  }

  do {
    struct Person: Hashable, Codable {
      var name: String
    }
    var dict = [Person(name: "br1"): 5, Person(name: "br2"): 8]
    dict[Person(name: "br3")] = nil
    let data = try JSONEncoder().encode(dict)
    print(#function, String(decoding: data, as: UTF8.self))
  } catch {
    print(error)
  }

  do {
    var dict = [5: 5, 8: 8]
    dict[16] = 16
    let data = try JSONEncoder().encode(dict)
    print(#function, String(decoding: data, as: UTF8.self))
  } catch {
    print(error)
  }


}

 test()


func test2() {
  let jsonString = #"""
    [
      "enhance", 5
    ]
    """#
  let data = jsonString.data(using: .utf8)!
  do {
    let dict = try JSONDecoder().decode(Dictionary<EnumType, Int>.self, from: data)
    print(#function, dict)
  } catch {
    print(#function, error)
  }

  do {
    let dict = try JSONDecoder().decode(Dictionary<StructType, Int>.self, from: data)
    print(#function, dict)
  } catch {
    print(#function, error)
  }
}

test2()
