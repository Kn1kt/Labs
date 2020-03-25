import Foundation

// Struct containing Nodes in Linked List
public struct LinkedList<Value> {
  
  // Front of list
  public var head: Node<Value>?
  
  // End of list
  public var tail: Node<Value>?
  
  // Save memberwise initializer
  public init() {}
  
  // Check for Nodes absence
  public var isEmpty: Bool {
    return head == nil
  }
  
  // MARK: - Adding Nodes
  // Add new Node at the front of list
  public mutating func push(_ value: Value) {
    head = Node(value: value, next: head)
    if tail == nil {
      tail = head
    }
  }
  
  // Add new Node at the end of the list
  public mutating func append(_ value: Value) {
    // If list is empty - push Node
    guard !isEmpty else {
      push(value)
      return
    }
    
    // Add Node at the end of list
    tail!.next = Node(value: value)
    
    // Assign new value to tail
    tail = tail!.next
    
  }
  
  // Find a particular Node in list
  public func node(at index: Int) -> Node<Value>? {
    var currentNode = head
    var currentIndex: Int = 0
    
    while currentNode != nil && currentIndex < index {
      currentNode = currentNode!.next
      currentIndex += 1
    }
    
    return currentNode
  }
  
  // Add new Node after a particular node of the list
  @discardableResult
  public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
    // If need add after last Node in the list
    guard tail !== node else {
      append(value)
      return tail!
    }
    
    node.next = Node(value: value, next: node.next)
    return node.next!
  }
  
  // Add new node at position index
  @discardableResult
  public mutating func insert(_ value: Value, at index: Int) -> Node<Value>?{
    // If need add Node at the front of the list
    if index == 0 {
      push(value)
      return head!
      
    } else {
      guard let previousNode = node(at: index - 1), index > 0 else { return nil }
      return insert(value, after: previousNode)
    }
  }
  
  // MARK: - Deleting Nodes
  // Remove Node at the front of the list
  @discardableResult
  public mutating func pop() -> Value? {
    
    // Do it no matter what happens
    defer {
      head = head?.next
      if isEmpty {
        tail = nil
      }
    }
    return head?.value
  }
  
  // Remove Node at the end of the list
  @discardableResult
  public mutating func removeLast() -> Value? {
    
    // Check head
    guard let head = head else { return nil }
    
    // If only one Node in list
    guard head.next != nil else { return pop() }
    
    var previousNode = head
    var currentNode = head
    
    while let nextNode = currentNode.next {
      previousNode = currentNode
      currentNode = nextNode
    }
    
    previousNode.next = nil
    tail = previousNode
    return currentNode.value
  }
  
  // Remove Node at particular Node
  @discardableResult
  public mutating func remove(after node: Node<Value>) -> Value? {
    
    defer {
      if node.next === tail {
        tail = node
      }
      node.next = node.next?.next
    }
    
    return node.next?.value
  }
}
// MARK: - Adopt Collection protocol

extension LinkedList: Collection {
  
  public struct Index: Comparable {
    
    public var node: Node<Value>?
    
    static public func == (lhs: Index, rhs: Index) -> Bool {
      switch (lhs.node, rhs.node) {
      case let (left?, right?):
        return left.next === right.next
      case (nil, nil):
        return true
      default:
        return false
      }
    }
    
    static public func < (lhs: Index, rhs: Index) -> Bool {
      guard lhs != rhs else { return false }
      let nodes = sequence(first: lhs.node) { $0?.next }
      return nodes.contains { $0 === rhs.node }
    }
  }
  
  public var startIndex: Index {
    return Index(node: head)
  }
  
  public var endIndex: Index {
    return Index(node: tail?.next)
  }
  
  public func index(after i: Index) -> Index {
    return Index(node: i.node?.next)
  }
  
  public subscript(position: Index) -> Value {
    get {
      return position.node!.value
    }
    set {
      position.node!.value = newValue
    }
  }
}

// MARK: - Description
// Simple description of list
extension LinkedList: CustomStringConvertible {
  
  public var description: String {
    guard let head = head else {
      return "Empty list"
    }
    return String(describing: head)
  }
}
