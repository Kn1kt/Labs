import Foundation

public class BTreeIterator<Key: Comparable, Value>: IteratorProtocol {
  public typealias Element = [(Key, Value)]
  
  private var queue = QueueStack<BTreeNode<Key, Value>>()
  
  public init?(tree: BTree<Key, Value>) {
    guard !tree.isEmpty else {
      return nil
    }
    
    queue.enqueue(tree.rootNode)
  }
  
  public func next() -> [(Key, Value)]? {
    guard let node = queue.dequeue() else {
      return nil
    }
    node.children?.forEach { queue.enqueue($0) }
    
    return node.elements
  }
}
