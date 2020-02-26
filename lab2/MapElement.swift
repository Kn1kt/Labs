import Foundation

public protocol MapElementProtocol {
  associatedtype Key: Comparable
  associatedtype Value
  
  var key: Key { get }
  var value: Value { get set }
  
  init(key: Key, value: Value)
}

public struct MapElement<Key, Value> where Key: Comparable {
  public let key: Key
  public var value: Value
  
  public init(key: Key, value: Value) {
    self.key = key
    self.value = value
  }
}

// MARK: - MapElementProtocol
extension MapElement: MapElementProtocol {}

  // MARK: - Comparable
extension MapElement: Comparable {
  public static func < (lhs: MapElement<Key, Value>, rhs: MapElement<Key, Value>) -> Bool {
    return lhs.key < rhs.key
  }
  
  public static func == (lhs: MapElement<Key, Value>, rhs: MapElement<Key, Value>) -> Bool {
    return lhs.key == rhs.key
  }
}

  // MARK: - CustomStringConvertible
extension MapElement: CustomStringConvertible {
  public var description: String {
    return "\(value)"
  }
}
