import Foundation

public struct HashTable<Key: Hashable, Value> {
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = LinkedList<Element>
  private var buckets: [Bucket]
  
  /// The multiplier for rehashing up hash table
  private let multiplier = 2
  
  /// The number of key-value pairs in the hash table.
  private(set) public var count = 0
  
  /// A Boolean value that indicates whether the hash table is empty.
  public var isEmpty: Bool { return count == 0 }
  
  
  /// Value that indicate maximum load of hash table
  public var loadFactor: Float {
    didSet {
      print("loadFactorChanged from \(oldValue) to \(loadFactor)")
      checkCapacity()
    }
  }
  
  /// Value that show current workload of hash table
  public var currentWorkload: Float {
    return Float(count) / Float(buckets.count)
  }
  
  /**
   Create a hash table with the given capacity.
   */
  public init(capacity: Int, loadFactor: Float = 2.0) {
    assert(capacity > 0)
    self.loadFactor = loadFactor
    self.buckets = Array<Bucket>(repeatElement(Bucket(), count: capacity))
  }
  
  /**
   Accesses the value associated with
   the given key for reading and writing.
   */
  public subscript(key: Key) -> Value? {
    get {
      return value(forKey: key)
    }
    set {
      if let value = newValue {
        updateValue(value, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
  }
  
  /**
   Check workload of  hash table.
  */
  private mutating func checkCapacity() {
    while currentWorkload > loadFactor {
      rehashUp(newSize: 2 * buckets.count + 1)
    }
  }
  
  /**
   Rehash up hash table.
  */
  private mutating func rehashUp(newSize: Int) {
    let oldBuckets = buckets
    buckets = Array<Bucket>(repeatElement(Bucket(), count: newSize))
    count = 0
    
    oldBuckets.forEach { bucket in
      bucket.forEach { element in
        updateValue(element.value, forKey: element.key)
      }
    }
  }
  
  public mutating func decreaseCapacity(to newSize: Int) {
    guard newSize > 0 && newSize < buckets.count else {
      fatalError()
    }
    
    rehashUp(newSize: newSize)
    checkCapacity()
  }
  
  /**
   Returns the value for the given key.
   */
  public func value(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    
    let element = buckets[index].first { $0.key == key }
    return element?.value
  }
  
  /**
   Updates the value stored in the hash table for the given key,
   or adds a new key-value pair if the key does not exist.
   */
  @discardableResult
  public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
    checkCapacity()
    
    let index = self.index(forKey: key)
    if let existingNodeIndex = buckets[index].firstIndex(where: { $0.key == key}) {
      defer {
        existingNodeIndex.node?.value.value = value
      }
      
      return buckets[index][existingNodeIndex].value
    }
    
    // This key isn't in the bucket yet; add it to the chain.
    buckets[index].push((key, value))
    count += 1
    return nil
  }
  
  /**
   Removes the given key and its
   associated value from the hash table.
   */
  @discardableResult
  public mutating func removeValue(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    
    guard !buckets[index].isEmpty else { return nil }
    
    // Find the element in the bucket's chain and remove it.
    var previousNodeIndex: LinkedList<Element>.Index = buckets[index].startIndex
    
    for currentNodeIndex in buckets[index].indices {
      if let node = currentNodeIndex.node,
        node.value.key == key {
        
        if previousNodeIndex == currentNodeIndex {
          buckets[index].pop()
        } else {
          buckets[index].remove(after: previousNodeIndex.node!)
        }
        
        count -= 1
        return node.value.value
      }
      
      previousNodeIndex = currentNodeIndex
    }
    
    return nil  // key not in hash table
  }
  
  /**
   Removes all key-value pairs from the hash table.
   */
  public mutating func removeAll() {
    buckets = Array<Bucket>(repeatElement(Bucket(), count: buckets.count))
    count = 0
  }
  
  /**
   Returns the given key's array index.
   */
  private func index(forKey key: Key) -> Int {
    return abs(key.hashValue % buckets.count)
  }
}

extension HashTable: CustomStringConvertible {
  /// A string that represents the contents of the hash table.
  public var description: String {
    let pairs = buckets.flatMap { b in b.map { e in "\(e.key) = \(e.value)" } }
    return pairs.joined(separator: ", ")
  }
  
  /// A string that represents the contents of
  /// the hash table, suitable for debugging.
  public var debugDescription: String {
    var str = ""
    for (i, bucket) in buckets.enumerated() {
      let pairs = bucket.map { e in "\(e.key) = \(e.value)" }
      str += "bucket \(i): " + pairs.joined(separator: ", ") + "\n"
    }
    return str
  }
}

