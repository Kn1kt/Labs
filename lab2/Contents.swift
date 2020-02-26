import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

print("TESTS")

var tree = AVLTree<MapElement<String, Int>>()

tree.insert(MapElement(key: "1", value: 1))
tree.insert(MapElement(key: "2", value: 2))
tree.insert(MapElement(key: "3", value: 3))
tree.insert(MapElement(key: "4", value: 4))
tree.insert(MapElement(key: "5", value: 5))
tree.insert(MapElement(key: "6", value: 6))
tree.insert(MapElement(key: "7", value: 7))
tree.insert(MapElement(key: "8", value: 8))
tree.insert(MapElement(key: "9", value: 9))
print(tree)

tree.contains("11")
tree["9"]
tree["9"] = 10
tree["9"]
tree["9"] = nil
tree["9"] = 9
print(tree)

//let it = tree.makeIterator(type: .inOrder)
//while let next = it.next() {
//  print(next)
//}
