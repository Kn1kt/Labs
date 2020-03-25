import Foundation

public class AVLTreeIterator<Element: Comparable>: IteratorProtocol {
  
  public enum Traverse {
    case inOrder
    case preOrder
    case postOrder
  }
  
  private let type: Traverse!
  private var currentNode: AVLNode<Element>?
  
  public init(tree: AVLTree<Element>, type: Traverse) {
    self.type = type
    guard let root = tree.root else { return }
    
    switch type {
    case .preOrder:
       currentNode = root
    default:
      currentNode = root
      while let left = currentNode?.leftChild {
        currentNode = left
      }
    }
  }
  
  public func next() -> Element? {
    guard let _ = currentNode else { return nil }
    
    switch type {
    case .inOrder:
      return traverseInOrder()
    case .preOrder:
      return traversePreOrder()
    case .postOrder:
      return traversePostOrder()
    case .none:
      fatalError()
    }
  }
  
  private func traverseInOrder() -> Element {
    let result = currentNode!.value
    
    if var pivot = currentNode?.rightChild {
      
      while let left = pivot.leftChild {
        pivot = left
      }
      currentNode = pivot
      
    } else {
    
      while true {
        guard let parent = currentNode?.parent else {
          currentNode = nil
          break
        }
        
        if currentNode === parent.leftChild {
          currentNode = parent
          break
        }
        
        currentNode = parent
      }
    }
    
    return result
  }
  
  private func traversePreOrder() -> Element {
    let result = currentNode!.value
    
    if let left = currentNode?.leftChild {
      currentNode = left
    } else {
      
      while true {
        guard let parent = currentNode?.parent else {
          currentNode = nil
          break
        }
        
        if currentNode === parent.leftChild,
          let right = parent.rightChild {
          currentNode = right
          break
        }
        
        currentNode = parent
      }
    }
    
    return result
  }
  
  private func traversePostOrder() -> Element {
    let result = currentNode!.value
    
    if let parent = currentNode?.parent {
      if parent.leftChild === currentNode {
        var pivot = parent.rightChild
        while let left = pivot?.leftChild {
          pivot = left
        }
        
        currentNode = pivot
      } else {
        currentNode = parent
      }
    } else {
      currentNode = nil
    }
    
    return result
  }
}
