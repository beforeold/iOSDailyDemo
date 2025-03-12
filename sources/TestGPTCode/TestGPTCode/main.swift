import Foundation

print("Hello, World!")

func bubbleSort(_ array: inout [Int]) {
  let n = array.count
  guard n > 1 else { return }

  for i in 0..<(n - 1) {
    var swapped = false
    for j in 0..<(n - i - 1) {
      if array[j] > array[j + 1] {
        array.swapAt(j, j + 1)
        swapped = true
      }
    }
    if !swapped { break }
  }
}

func testBubbleSort() {
  var numbers = [64, 34, 34, 25, 12, 22, 11, 90]
  print("Original array: \(numbers)")
  bubbleSort(&numbers)
  print("Sorted array: \(numbers)")
}

testBubbleSort()
