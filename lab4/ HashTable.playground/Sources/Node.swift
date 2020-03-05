import Foundation

// Just Node
public class Node<Value> {
  
  // Value of current Node
  public var value: Value
  
  // Link on next Node
  public var next: Node?
  
  public init(value: Value, next: Node? = nil) {
    self.value = value
    self.next = next
  }
}

// Simple description of list
extension Node: CustomStringConvertible {
  
  public var description: String {
    guard let next = next else {
      return "\(value)"
    }
    return "\(value) -> " + String(describing: next)
  }
}
