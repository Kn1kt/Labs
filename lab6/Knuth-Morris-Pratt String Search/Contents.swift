import Foundation

func indents(_ pattern: String) -> [Int]? {
  guard pattern.count > 0 else { return nil }
  let start = pattern.startIndex
  let length = pattern.count
  
  var indents = Array(repeating: 0, count: length)
  var i = 1
  var j = 0
  
  while i < length {
    let pi = pattern.index(start, offsetBy: i)
    let pj = pattern.index(start, offsetBy: j)
    
    if pattern[pi] == pattern[pj] {
      indents[i] = j + 1
      i += 1
      j += 1
      
    } else if j == 0 {
      indents[i] = 0
      i += 1
      
    } else {
      j = indents[j - 1]
    }
  }
  
  return indents
}

extension String {
  
  func indices(of pattern: String) -> [Index] {
    guard let indents = indents(pattern) else { return [] }
    
    var indices = [Index]()
    
    let pLength = pattern.count
    let sLength = count
    var k = 0
    var l = 0
    
    while k < sLength {
      let sk = index(startIndex, offsetBy: k)
      let pl = pattern.index(pattern.startIndex, offsetBy: l)
      
      if self[sk] == pattern[pl] {
        k += 1
        l += 1
        if l == pLength {
          let index = self.index(sk, offsetBy: -(pLength - 1))
          indices.append(index)
          l = 0
        }
        
      } else if l == 0 {
        k += 1
      } else {
        l = indents[l - 1]
      }
    }
    
    return indices
  }
}

let animals = "🐶🐮🐔🐷🐮🐱🐮"
let s = "Hello, World, Wordd,World"
let string = "abcabeabcabcabd"

let indices = string.indices(of: "abcabd")
indices.forEach { index in
  let end = string.index(index, offsetBy: 6)
  print(string[index..<end], terminator: " ")
}
print()

let indices1 = s.indices(of: "World")
indices1.forEach { index in
  let end = s.index(index, offsetBy: 5)
  print(s[index..<end], terminator: " ")
}
print()

let indices2 = animals.indices(of: "🐮")
indices2.forEach { index in
  let end = animals.index(index, offsetBy: 1)
  print(animals[index..<end], terminator: " ")
}

