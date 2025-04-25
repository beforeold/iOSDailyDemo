import Foundation

struct Ingredient {
  let name: String
  let sortOrder: Int
}

let ingredients = [
  Ingredient(name: "cheese", sortOrder: 2),
  Ingredient(name: "potato", sortOrder: 1),
  Ingredient(name: "cream", sortOrder: 3),
]

do {
  let sortedIngredients = ingredients.sorted(using: KeyPathComparator(\.sortOrder))
  print(sortedIngredients)
}

print("\n")

do {
  let sortedIngredients = ingredients.sorted(using: KeyPathComparator(\.name, order: .reverse))
  print("name reversed", sortedIngredients, separator: "\n")
}
