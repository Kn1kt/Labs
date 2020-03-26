import Foundation

public class AdjacencyMatrix<T: Comparable>: Graph {
  
  private var vertices: [Vertex<T>] = []
  private var weights: [[Double?]] = []
  
  public init() {}
  
  public func createVertex(data: T) -> Vertex<T> {
    let vertex = Vertex(index: vertices.count, data: data)
    vertices.append(vertex)
    
    for i in 0..<weights.count {
      weights[i].append(nil)
    }
    let row = [Double?](repeating: nil, count: vertices.count)
    weights.append(row)
    
    return vertex
  }
  
  public func vertex(for data: T) -> Vertex<T>? {
    return vertices.first { $0.data == data }
  }
  
  public func addEdge(_ edge: Edge<T>) {
    let source: Vertex<T>
    if let s = vertex(for: edge.source.data) {
      source = s
    } else {
      source = createVertex(data: edge.source.data)
    }
    
    let destination: Vertex<T>
    if let d = vertex(for: edge.destination.data) {
      destination = d
    } else {
      destination = createVertex(data: edge.destination.data)
    }
    
    addDirectedEdge(from: source, to: destination, weight: edge.weight)
  }
  
  public func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
    weights[source.index][destination.index] = weight
  }
  
  public func edges(from source: Vertex<T>) -> [Edge<T>] {
    var edges: [Edge<T>] = []
    
    for column in 0..<weights.count {
      
      if let weight = weights[source.index][column] {
        edges.append(Edge(source: source, destination: vertices[column], weight: weight))
      }
    }
    return edges
  }
  
  public func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
    return weights[source.index][destination.index]
  }
}

extension AdjacencyMatrix: CustomStringConvertible {
  
  public var description: String {
    
    let verticesDescription = vertices.map { "\($0)" }.joined(separator: "\n")
    
    var grid: [String] = []
    for i in 0..<weights.count {
      var row = ""
      
      for j in 0..<weights.count {
        
        if let value = weights[i][j] {
          row += "\(value)\t"
          
        } else {
          row += "ø\t\t"
        }
      }
      grid.append(row)
    }
    let edgesDescriprion = grid.joined(separator: "\n")
    
    return "\(verticesDescription)\n\n\(edgesDescriprion)"
  }
}

  // MARK: - Kruskal's Algorithm
public extension AdjacencyMatrix {
  typealias UnionFind = UnionFindQuickFind<Vertex<T>>
  typealias Graph = AdjacencyMatrix<T>

  func minimumSpanningTreeKruskal() -> (cost: Double, tree: Graph) {
    var cost: Double = 0
    let tree = Graph()
    let sortedEdgeListByWeight = vertices.flatMap { edges(from: $0) }
      .sorted(by: { $0.weight ?? 0 < $1.weight ?? 0 })

    var unionFind = UnionFind()
    for vertex in vertices {
      unionFind.addSetWith(vertex)
    }

    for edge in sortedEdgeListByWeight {
      let v1 = edge.source
      let v2 = edge.destination
      if !unionFind.inSameSet(v1, and: v2) {
        cost += edge.weight ?? 0
        
        tree.addEdge(edge)
        unionFind.unionSetsContaining(v1, and: v2)
      }
    }

    return (cost: cost, tree: tree)
  }
}
