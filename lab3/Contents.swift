print("hey")

let tree = BTree<Int, String>(order: 2)
tree?.insert("1", for: 1)
tree?.insert("2", for: 2)
tree?.insert("3", for: 3)
tree?.insert("4", for: 4)
tree?.insert("5", for: 5)
tree?.insert("6", for: 6)
tree?.insert("7", for: 7)
tree?.insert("8", for: 8)
tree?.insert("9", for: 9)

guard let tree = tree else {
  fatalError()
}

//tree.remove(1)
//tree.remove(6)
//tree.removeAll()

(1...9).forEach { i in
  var str = "\(i) : "
  if let value = tree.value(for: i) {
    str += "\(value)"
  } else {
    str += "nil"
  }
  
  print(str)
}

if let iter = tree.makeIterator() {
  while let elements = iter.next() {
    print(elements)
  }
}

