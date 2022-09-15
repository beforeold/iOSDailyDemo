import Cocoa

var dict :[String:String?] = [:]
// first try
dict = ["key": "value"]
dict["key"] = Optional<Optional<String>>.none
dict
// second try
dict = ["key": "value"]
dict["key"] = Optional<String>.none
dict
// third try
dict = ["key": "value"]
dict["key"] = nil
dict
// forth try
dict = ["key": "value"]
let nilValue:String? = nil
dict["key"] = nilValue
dict
// fifth try
dict = ["key": "value"]
let nilValue2:String?? = nil
dict["key"] = nilValue2
dict

var stack = [Int]()
stack.popLast()

let ret = "hello".map { ($0, 1) }
let dd = Dictionary(ret, uniquingKeysWith: +)


func twoSum(nums: [Int], target: Int) -> Bool {
    var set = Set<Int>()
    
    for i in nums {
        if set.contains(target - i) { return true }
        
        set.insert(i)
    }
    
    return false
}

twoSum(nums: [1, 2, 3], target: 5)

func twoSumIndex(nums: [Int], target: Int) -> (Int, Int) {
    var dict = [Int: Int]()
    for (index, item) in nums.enumerated() {
        if let findIndex = dict[target - item] {
            return (findIndex, index)
        }
        
        dict[item] = index
    }
    
    fatalError()
}

twoSumIndex(nums: [1, 2, 3], target: 5)


let str = "bar"
String(str.sorted())

let arr = [3, 1, 2]

func reverse(string: [Character]) -> String {
    var ret = [Character]()
    var prevEmptyIndex = -1
    for (index, item) in string.enumerated() {
        if item == " " {
            ret.insert(contentsOf: string[prevEmptyIndex+1..<index], at: 0)
            ret.insert(item, at: 0)
            prevEmptyIndex = index
        } else if index == string.count - 1 {
            ret.insert(contentsOf: string[prevEmptyIndex+1...index], at: 0)
        }
    }
    
    return String(ret)
}

let re = reverse(string: "1 2 3".map{$0})
re

fileprivate func _reverse(chars: inout [Character], start: Int, end: Int) {
    var start = start, end = end
    
    while start < end {
        (chars[start], chars[end]) = (chars[end], chars[start])
        start += 1
        end -= 1
    }
    print(chars)
}

func reverse2(string: String) -> String {
    var chars = string.map { $0 }
    print("1", String(chars))
    _reverse(chars: &chars, start: 0, end: chars.count - 1)
    print("2", String(chars))
    
    var start = 0
    for i in 0..<chars.count {
        if i == chars.count - 1 || chars[i+1] == " " {
            _reverse(chars: &chars, start: start, end: i)
            start = i + 2
            print(start, i)
        }
    }
    
    return String(chars)
}

reverse2(string: "hello    world")


class LinkedList<T> {
    class Node<T> {
        var val: T
        var next: Node<T>?
        
        init(_ val: T) {
            self.val = val
        }
        
        var desc: String {
            var ret = ""
            var node: Node<T>? = self
            while let taken = node {
                ret += String(taken.val as! Int) // debug only
                node = node?.next
            }
            
            return ret
        }
    }
    
    var head: Node<T>?
    var tail: Node<T>?
    
    func appendToTail(val: T) {
        let node = Node(val)
        if let tail = tail {
            tail.next = node
            self.tail = node
        } else {
            head = node
            tail = node
        }
    }
    
    func appendToHead(val: T) {
        let node = Node(val)
        if let head = head {
            node.next = head
            self.head = node
        } else {
            head = node
            tail = node
        }
    }
}

extension LinkedList where T: Comparable {
    static func getLeftList(head: Node<T>?, x: T) -> Node<T>? {
        let fakeHead = Node(0 as! T)
        
        var tailNode = fakeHead, node = head;
        
        while let taken = node {
            if taken.val < x {
                tailNode.next = node
                tailNode = taken
            }
            node = node?.next
        }
        
        tailNode.next = nil
        
        return fakeHead.next
    }
    
    static func partition(head: Node<T>?, x: T) -> Node<T>? {
        let leftDummyHead = Node(0 as! T), rightDummyHead = Node(0 as! T)
        var leftTail = leftDummyHead, rightTail = rightDummyHead
        var node = head
        
        while let taken = node {
            if taken.val < x {
                leftTail.next = taken
                leftTail = taken
            } else {
                rightTail.next = taken
                rightTail = taken
            }
            node = node?.next
        }
        
        rightTail.next = nil
        leftTail.next = rightDummyHead.next
        
        return leftDummyHead.next
    }
}

let head = LinkedList<Int>.Node(3)
head.next = LinkedList<Int>.Node(2)
head.next?.next = LinkedList<Int>.Node(3)


let left = LinkedList.getLeftList(head: head, x: 3)
let leftDesc = left?.desc
