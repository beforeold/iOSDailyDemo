import Foundation

var dict: [String: Any] = [
  "id": 3 as Int?,
  "name": nil as String?,
]

print(dict)
print(dict as NSDictionary)

/*
 ["id": Optional(3), "name": nil]
 {
     id = 3;
     name
 */
