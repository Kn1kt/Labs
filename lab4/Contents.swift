import Foundation

var table = HashTable<String, Int>(capacity: 10)
table.loadFactor = 0.75

(0...9).forEach {
  let str = "\(String(describing: $0))"
  table[str] = $0
  print(table.currentWorkload)
  print(table.debugDescription)
}

//table.decreaseCapacity(to: 15)

//table.removeAll()
table.count
table.currentWorkload
print(table.currentWorkload)
print(table.debugDescription)
