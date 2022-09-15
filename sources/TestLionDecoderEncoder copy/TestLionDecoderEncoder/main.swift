
import Foundation


struct Person: Codable {
    var name: String
    var age: Int
    var isVIP: Bool?
    
    var personValueList: [Int]
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.age = try? container.decode(Int.self, forKey: .age)
//        self.isVIP = try? container.decode(Bool.self, forKey: .isVIP)
//    }
}

struct Box: Codable {
    var value: Int
}

struct Model: Codable {
    var key1: Double
    
    var valueList: [Box]
    
    var person: Person
    
    var dict: [String: String]?
}

extension Model {
    private static var maps: [CodingKeys: Any] {
        return [.key1: "", .valueList: []]
    }
}

//
var data = """
 {
    "key1": 5,
    "valueList": [],
    "person": {
        "name": "brook",
        "age": 15,
        "isVIP": null,
        "personValueList": [1, "2", 3]
    }
}
""".data(using: .utf8)!

func decodingNullWithFoundation() {
    do {
        let optionalModel = try Foundation.JSONDecoder().decode(Optional<Model>.self, from: data)
        print(optionalModel as Any)
    } catch {
        print(error)
    }
}


func applyCustomDeocding() {

    do {
        let model1 = try JSONDecoder().decode(Model.self, from: data)
        print("custom decoded key1", model1.key1)
        
        data = try JSONEncoder().encode(model1)
        
        let model2 = try Foundation.JSONDecoder().decode(Model.self, from: data)
        print("foundation decoder:", model2.key1)
        
        let model3 = try JSONDecoder().decode(Model.self, from: data)
        print("custom re decoded", model3.key1)
        
        print("person name", model3.person.name)
        print("person age", model3.person.age == 15)
        
        print("double list", model3.valueList)
        
    } catch {
        print("failed with error", error)
    }
    print("--- end")
}

applyCustomDeocding()
//decodingNullWithFoundation()


protocol configurable {
    static func defaults() -> [String: Any]
}


class WRUQ: configurable {
    var name: String = ""
    
    static func defaults() -> [String: Any] {
        [:]
    }
}

