
public struct AVLTree<Element: Comparable> {
  
  public private(set) var root: AVLNode<Element>?
  
  public var isEmpty: Bool {
    return root == nil
  }
  
  public private(set) var count: Int = 0
  
  public init() {}
}

extension AVLTree: CustomStringConvertible {
  
  public var description: String {
    guard let root = root else { return "empty tree" }
    return String(describing: root)
  }
}

extension AVLTree {
  
  public mutating func insert(_ value: Element) {
    root = insert(from: root, value: value)
    count += 1
  }
  
  private func insert(from node: AVLNode<Element>?, value: Element) -> AVLNode<Element> {
    guard let node = node else {
      return AVLNode(value: value)
    }
    if value < node.value {
      node.leftChild = insert(from: node.leftChild, value: value)
    } else {
      node.rightChild = insert(from: node.rightChild, value: value)
    }
    
    let balancedNode = balanced(node)
    balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
    return balancedNode
  }
  
  private func leftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
    
    let pivot = node.rightChild!
    
    node.rightChild = pivot.leftChild
    
    pivot.leftChild = node
    
    node.height = max(node.leftHeight, node.rightHeight) + 1
    pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
    
    return pivot
  }
  
  private func rightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
    
    let pivot = node.leftChild!
    
    node.leftChild = pivot.rightChild
    
    pivot.rightChild = node
    
    node.height = max(node.leftHeight, node.rightHeight) + 1
    pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
    
    return pivot
    
  }
  
  private func rightLeftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
    
    guard let rightChild = node.rightChild else {
      return node
    }
    node.rightChild = rightRotate(rightChild)
    
    return leftRotate(node)
  }
  
  private func leftRightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
    
    guard let leftChild = node.leftChild else {
      return node
    }
    node.leftChild = leftRotate(leftChild)
    
    return rightRotate(node)
  }
  
  private func balanced(_ node: AVLNode<Element>) -> AVLNode<Element> {
    
    switch node.balanceFactor {
    case 2:
      if let leftChild = node.leftChild, leftChild.balanceFactor == -1 {
        return leftRightRotate(node)
      } else {
        return rightRotate(node)
      }
    case -2:
      if let rightChild = node.rightChild, rightChild.balanceFactor == 1 {
        return rightLeftRotate(node)
      } else {
        return leftRotate(node)
      }
    default:
      return node
    }
  }
}

extension AVLTree {
  
  public func contains(_ value: Element) -> Bool {
    var current = root
    while let node = current {
      if node.value == value {
        return true
      }
      if value < node.value {
        current = node.leftChild
      } else {
        current = node.rightChild
      }
    }
    return false
  }
}

private extension AVLNode {
  
  var min: AVLNode {
    return leftChild?.min ?? self
  }
}

extension AVLTree {
  
  public mutating func removeAll() {
    self.root = nil
    count = 0
  }
  
  public mutating func remove(_ value: Element) {
    root = remove(node: root, value: value)
    count -= 1
  }
  
  private func remove(node: AVLNode<Element>?, value: Element) -> AVLNode<Element>? {
    guard let node = node else {
      return nil
    }
    if value == node.value {
      if node.leftChild == nil && node.rightChild == nil {
        return nil
      }
      if node.leftChild == nil {
        return node.rightChild
      }
      if node.rightChild == nil {
        return node.leftChild
      }
      node.value = node.rightChild!.min.value
      node.rightChild = remove(node: node.rightChild, value: node.value)
    } else if value < node.value {
      node.leftChild = remove(node: node.leftChild, value: value)
    } else {
      node.rightChild = remove(node: node.rightChild, value: value)
    }
    
    let balancedNode = balanced(node)
    balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
    return balancedNode
  }
}

public extension AVLTree where Element: MapElementProtocol {
  
  private func element(for key: Element.Key) -> Element? {
    return node(for: key)?.value
  }
  
  private func node(for key: Element.Key) -> AVLNode<Element>? {
    var current = root
    while let node = current {
      if node.value.key == key {
        return node
      }
      if key < node.value.key {
        current = node.leftChild
      } else {
        current = node.rightChild
      }
    }
    return nil
  }
  
  func contains(_ key: Element.Key) -> Bool {
    guard let _ = element(for: key) else {
      return false
    }
    
    return true
  }
  
  subscript(key: Element.Key) -> Element.Value? {
    get {
      guard let element = element(for: key) else {
        return nil
      }
      
      return element.value
    }
    
    set(newValue) {
      guard let newValue = newValue else {
        if let element = element(for: key) {
          remove(element)
        }
        return
      }
      
      if let existed = node(for: key) {
        existed.value.value = newValue
      } else {
        insert(Element(key: key, value: newValue))
      }
    }
  }
}

extension AVLTree {
  
  public func makeIterator(type: AVLTreeIterator<Element>.Traverse) -> AVLTreeIterator<Element> {
    return AVLTreeIterator(tree: self, type: type)
  }
}
