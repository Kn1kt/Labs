import Foundation

public struct Heap<Element: Equatable> {
  
  private var elements: [Element] = []
  let sort: (Element, Element) -> Bool
  
  var isEmpty: Bool {
    return elements.isEmpty
  }
  
  var count: Int {
    return elements.count
  }
  
  init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
    self.sort = sort
    self.elements = elements
    
    if !self.elements.isEmpty {
      for i in stride(from: self.elements.count / 2 - 1, through: 0, by: -1) {
        siftDown(from: i)
      }
    }
  }
  
  func peek() -> Element? {
    return elements.first
  }
  
  private func leftChildIndex(ofParentAt index: Int) -> Int {
    return (2 * index) + 1
  }
  
  private func rightChildIndex(ofParentAt index: Int) -> Int {
    return (2 * index) + 2
  }
  
  private func parentIndex(ofChildAt index: Int) -> Int {
    return (index - 1) / 2
  }
  
  private mutating func siftUp(from index: Int) {
    var child = index
    var parent = parentIndex(ofChildAt: child)
    
    while child > 0 && sort(elements[child], elements[parent]) {
      elements.swapAt(child, parent)
      child = parent
      parent = parentIndex(ofChildAt: child)
    }
  }
  
 private  mutating func siftDown(from index: Int) {
    var parent = index
    while true {
      let left = leftChildIndex(ofParentAt: parent)
      let right = rightChildIndex(ofParentAt: parent)
      var candidate = parent
      
      if left < count && sort(elements[left], elements[candidate]) {
        candidate = left
      }
      if right < count && sort(elements[right], elements[candidate]) {
        candidate = right
      }
      if candidate == parent {
        return
      }
      elements.swapAt(parent, candidate)
      parent = candidate
    }
  }
  
  mutating func insert(_ element: Element) {
    elements.append(element)
    siftUp(from: elements.count - 1)
  }
  
  mutating func remove() -> Element? {
    
    guard !isEmpty else {
      return nil
    }
    
    elements.swapAt(0, count - 1)
    defer {
      siftDown(from: 0)
    }
    
    return elements.removeLast()
  }
  
  mutating func remove(at index: Int) -> Element? {
    
    guard index < elements.count else {
      return nil
    }
    if index == elements.count - 1 {
      return elements.removeLast()
    } else {
      elements.swapAt(index, elements.count - 1)
      defer {
        siftDown(from: index)
        siftUp(from: index)
      }
      return elements.removeLast()
    }
  }
  
  func index(of element: Element, startingAt i: Int) -> Int? {
    
    if i >= count {
      return nil
    }
    if sort(element, elements[i]) {
      return nil
    }
    if element == elements[i] {
      return i
    }
    if let j = index(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
      return j
    }
    if let j = index(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
      return j
    }
    
    return nil
  }
  
}
