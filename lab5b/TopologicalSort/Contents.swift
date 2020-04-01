import UIKit

var str = "Hello, playground"

let graph = AdjacencyList<String>()
let a = graph.createVertex(data: "A")
let b = graph.createVertex(data: "B")
let c = graph.createVertex(data: "C")
let d = graph.createVertex(data: "D")

#imageLiteral(resourceName: "Graph.png")

graph.add(.directed, from: a, to: d, weight: nil)
graph.add(.directed, from: d, to: b, weight: nil)
graph.add(.directed, from: d, to: c, weight: nil)
graph.add(.directed, from: c, to: b, weight: nil)

  //CYCLE
//graph.add(.directed, from: b, to: a, weight: nil)

print(graph)

if let vertices = graph.topologicalSort() {
  vertices.forEach { print($0) }
}
