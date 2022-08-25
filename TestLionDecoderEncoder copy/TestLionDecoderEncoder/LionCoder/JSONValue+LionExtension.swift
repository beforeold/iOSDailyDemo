
import Foundation

extension JSONValue {
    var lion_bool: Bool {
        switch self {
        case .string(let string):
            return (string as NSString).boolValue
            
        case .number(let string):
            return (string as NSString).boolValue
        case .bool(let bool):
            return bool
    
        default:
            return false
        }
    }
    
    static var lion_null = JSONValue.string("0")
}
