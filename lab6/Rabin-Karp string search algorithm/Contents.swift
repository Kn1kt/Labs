import Foundation

public func hash(_ string: String) -> Int {
  return string.reduce(0) { (result: Int, character: Character) in
    result &+ character.hashValue
  }
}

public func nextHash(prevHash: Int, dropped: Character, added: Character) -> Int {
  return prevHash &- dropped.hashValue &+ added.hashValue
}

public func search(text: String, pattern: String) -> [String.Index] {
  if text.count < pattern.count {
    return []
  }
  
  var indices = [String.Index]()
  
  let patternHash = hash(pattern)
  let patternLength = pattern.count - 1
  let offset = text.index(text.startIndex, offsetBy: patternLength)
  let firstText = String(text[...offset])
  let firstHash = hash(firstText)
  
  if patternHash == firstHash {
    if firstText == pattern {
      indices.append(text.startIndex)
    }
  }
  
  let start = text.index(after: text.startIndex)
  let end = text.index(text.endIndex, offsetBy: -patternLength)
  var prevHash = firstHash
  var i = start

  while i != end {
    let terminator = text.index(i, offsetBy: patternLength)
    let window = text[i...terminator]
    let prev = text.index(before: i)
    let windowHash = nextHash(prevHash: prevHash, dropped: text[prev], added: text[terminator])
    
    if windowHash == patternHash,
      pattern == window {
      indices.append(i)
    }
    
    prevHash = windowHash
    
    i = text.index(after: i)
  }
  
  return indices
}

let s = "Pump! The big dog jumped over the fox"

let indices = search(text: s, pattern: "ump")
indices.forEach { start in
  let end = s.index(start, offsetBy: 3)
  print(s[start..<end], terminator: " ")
}
print()

let animals = "🐭🐶🐔🐭🐷🐮🐱🐭"

let indices1 = search(text: animals, pattern: "🐭")
indices1.forEach { start in
  let end = animals.index(start, offsetBy: 1)
  print(animals[start..<end], terminator: " ")
}
