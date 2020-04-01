// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public enum EdgeType {
  
  case directed
  case undirected
}

public protocol Graph {
  
  associatedtype Element
  
  init()
  var vertices: [Vertex<Element>] { get }
  
  func createVertex(data: Element) -> Vertex<Element>
  func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
  func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?)
  func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
  func edges(from source: Vertex<Element>) -> [Edge<Element>]
  func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
}

extension Graph {
  
  public func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?) {
    addDirectedEdge(from: source, to: destination, weight: weight)
    addDirectedEdge(from: destination, to: source, weight: weight)
  }
  
  public func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
    switch edge {
    case .directed:
      addDirectedEdge(from: source, to: destination, weight: weight)
    case .undirected:
      addUndirectedEdge(between: source, and: destination, weight: weight)
    }
  }
}

extension Graph where Element: Hashable{
  
  private func depthFirstSearch(from source: Vertex<Element>,
                               gray: inout Set<Vertex<Element>>,
                               black: inout Set<Vertex<Element>>) -> [Vertex<Element>]? {
    var stack: Stack<Vertex<Element>> = []
    var visited: [Vertex<Element>] = []
    
    stack.push(source)
    gray.insert(source)
    
    outer: while let vertex = stack.peek() {
      if black.contains(vertex) {
        stack.pop()
        continue
      }
      
      let neighbors = edges(from: vertex)
      guard !neighbors.isEmpty else {
        visited.append(vertex)
        gray.remove(vertex)
        black.insert(vertex)
        stack.pop()
        continue
      }
      
      for edge in neighbors {
        if black.contains(edge.destination) { continue }
        
        if !gray.contains(edge.destination) {
          stack.push(edge.destination)
          gray.insert(edge.destination)
          continue outer
        } else {
          print("Cycle")
          return nil
        }
      }
      
      visited.append(vertex)
      gray.remove(vertex)
      black.insert(vertex)
      stack.pop()
    }
    
    return visited
  }
}

  // MARK: - Topological Sort

extension Graph where Element: Hashable {
  
  public func topologicalSort() -> [Vertex<Element>]? {
    guard !vertices.isEmpty else {
      return []
    }
    
    var sorted = [Vertex<Element>]()
    var gray = Set<Vertex<Element>>()
    var black = Set<Vertex<Element>>()
    
    for vertex in vertices {
      if let visited = depthFirstSearch(from: vertex,
                                        gray: &gray,
                                        black: &black) {
        sorted.append(contentsOf: visited)
      } else {
        return nil
      }
    }
    return sorted.reversed()
  }
  
  public func topologicalSort() -> [Vertex<Element>] {
    guard !vertices.isEmpty else {
      return []
    }

    var sorted = [Vertex<Element>]()
    var visited = Set<Vertex<Element>>()

    var processing = vertices

    while let vertex = processing.last {
      guard !visited.contains(vertex) else {
        processing.removeLast()
        continue
      }

      if let edge = edges(from: vertex).first(where: { !visited.contains($0.destination) }) {
        processing.append(edge.destination)
      } else {
        visited.insert(vertex)
        sorted.append(vertex)
        processing.removeLast()
      }
    }

    return sorted.reversed()
  }
}
