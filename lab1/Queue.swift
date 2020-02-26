import Foundation

public protocol Queue {
  associatedtype Element
  mutating func enqueue(_ element: Element) -> Bool
  mutating func dequeue() -> Element?
  var isEmpty: Bool { get }
  var peek: Element? { get }
}

public struct PriorityQueue<Element: Equatable>: Queue {
  
  private var heap: Heap<Element>
  
  public init<T>(sort: @escaping (Element, Element) -> Bool, elements: T) where T: Sequence, T.Element == Element {
    heap = Heap(sort: sort, elements: Array(elements))
  }
  
  public var isEmpty: Bool {
    return heap.isEmpty
  }
  
  public var peek: Element? {
    return heap.peek()
  }
  
  public mutating func enqueue(_ element: Element) -> Bool {
    heap.insert(element)
    return true
  }
  
  public mutating func dequeue() -> Element? {
    return heap.remove()
  }
}
