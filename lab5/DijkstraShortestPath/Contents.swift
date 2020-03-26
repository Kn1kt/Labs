import UIKit

var str = "Hello, playground"

let graph = AdjacencyList<String>()

//let a = graph.createVertex(data: "A")
//let b = graph.createVertex(data: "B")
//let c = graph.createVertex(data: "C")
//let d = graph.createVertex(data: "D")
//let e = graph.createVertex(data: "E")
//let f = graph.createVertex(data: "F")
//let g = graph.createVertex(data: "G")
//let h = graph.createVertex(data: "H")
//
//graph.add(.directed, from: a, to: b, weight: 8)
//graph.add(.directed, from: a, to: f, weight: 9)
//graph.add(.directed, from: a, to: g, weight: 1)
//graph.add(.directed, from: b, to: f, weight: 3)
//graph.add(.directed, from: b, to: e, weight: 1)
//graph.add(.directed, from: f, to: a, weight: 2)
//graph.add(.directed, from: h, to: f, weight: 2)
//graph.add(.directed, from: h, to: g, weight: 5)
//graph.add(.directed, from: g, to: c, weight: 3)
//graph.add(.directed, from: c, to: e, weight: 1)
//graph.add(.directed, from: c, to: b, weight: 3)
//graph.add(.undirected, from: e, to: c, weight: 8)
//graph.add(.directed, from: e, to: b, weight: 1)
//graph.add(.directed, from: e, to: d, weight: 2)
//
//let dijkstra = Dijkstra(graph: graph)
//let pathsFromA = dijkstra.shortestPath(from: a)
//let path = dijkstra.shortestPath(to: d, paths: pathsFromA)
//
//for edge in path {
//    print("\(edge.source) --|\(edge.weight ?? 0.0)|--> \(edge.destination)")
//}

var input: [String] = [
    "Anna Boris",
    "Boris Ivan",
    "Ivan Elena",
    "Elena John",
    "Ivan John",
    "Anna John"
]


while let string = readLine() {
    input.append(string)
}

let needFound = input.removeLast().split(separator: " ").map(String.init)
var splitted: [String] = []
input.forEach {
    let split = $0.split(separator: " ").map(String.init)
    splitted.append(contentsOf: split)
}
var vertices: [Vertex<String>] = []

Set(splitted).forEach {
    let vertex = graph.createVertex(data: $0)
    vertices.append(vertex)
}

input.forEach { string in
    let split = string.split(separator: " ").map(String.init)
    let start = vertices.first {
        $0.data == split[0]
    }
    let end = vertices.first {
        $0.data == split[1]
    }
    graph.add(.directed, from: start!, to: end!, weight: 1.0)
}

let dijkstra = Dijkstra(graph: graph)
let start = vertices.first {
    $0.data == needFound[0]
}
let end = vertices.first {
    $0.data == needFound[1]
}
let paths = dijkstra.shortestPath(from: start!)
let path = dijkstra.shortestPath(to: end!, paths: paths)

if path.isEmpty {
    print("-1")
} else {
    print("\(path.count - 1)")
}
