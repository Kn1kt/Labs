import UIKit

var priorityQueue = PriorityQueue(sort: <, elements: ["1", "12", "15", "2", "4", "5", "6"])
var priorityQueue1 = PriorityQueue(sort: >, elements: 1...12)

var toString = [String]()
while !priorityQueue.isEmpty {
  toString.append(priorityQueue.dequeue()!)
}

print(toString.joined(separator: " "))

var toString1 = [Int]()
while !priorityQueue1.isEmpty {
  print(priorityQueue1.dequeue())
}
print(priorityQueue1.dequeue())
print(toString1.map(String.init).joined(separator: " "))
