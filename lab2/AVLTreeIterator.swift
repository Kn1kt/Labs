import Foundation

public class AVLTreeIterator<Element: Comparable>: IteratorProtocol {
 
  public enum Traverse {
    case inOrder
    case preOrder
    case postOrder
  }
  
  private var elements = [Element]()
  private var index = 0
  
  public init(tree: AVLTree<Element>, type: Traverse) {
    guard let root = tree.root else { return }
    switch type {
    case .preOrder:
      root.traversePreOrder { elements.append($0) }
    case .inOrder:
      root.traverseInOrder { elements.append($0) }
    case .postOrder:
      root.traversePostOrder { elements.append($0) }
    }
  }
  
  public func next() -> Element? {
    defer { index += 1 }
    return index < elements.count ? elements[index] : nil
  }
  
}
