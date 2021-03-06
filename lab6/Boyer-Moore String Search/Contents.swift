import Foundation

extension String {
  func indices(of pattern: String, usingHorspoolImprovement: Bool = false) -> [Index] {
    // Cache the length of the search pattern because we're going to
    // use it a few times and it's expensive to calculate.
    let patternLength = pattern.count
    guard patternLength > 0, patternLength <= self.count else { return [] }
    
    // This points at the last character in the pattern.
    let p = pattern.index(before: pattern.endIndex)
    let lastChar = pattern[p]
    
    var indices = [Index]()
    
    // Make the skip table. This table determines how far we skip ahead
    // when a character from the pattern is found.
    var skipTable = [Character: Int]()
    for (i, c) in pattern.enumerated() {
      // In Horspool version we gonna skip ahead full pattern length
      // when it's last character from the pattern
      if usingHorspoolImprovement, i == (patternLength - 1) {
        if skipTable[c] == nil {
          skipTable[c] = patternLength
        }
      } else {
        skipTable[c] = patternLength - i - 1
      }
    }
    
    // The pattern is scanned right-to-left, so skip ahead in the string by
    // the length of the pattern. (Minus 1 because startIndex already points
    // at the first character in the source string.)
    var i = index(startIndex, offsetBy: patternLength - 1)
    
    // This is a helper function that steps backwards through both strings
    // until we find a character that doesn’t match, or until we’ve reached
    // the beginning of the pattern.
    func backwards() -> Index? {
      var q = p
      var j = i
      while q > pattern.startIndex {
        j = index(before: j)
        q = index(before: q)
        if self[j] != pattern[q] { return nil }
      }
      return j
    }
    
    // The main loop. Keep going until the end of the string is reached.
    while i < endIndex {
      let c = self[i]
      
      // Does the current character match the last character from the pattern?
      if c == lastChar {
        
        // There is a possible match. Do a brute-force search backwards.
        if let k = backwards() { indices.append(k) }
        
        if !usingHorspoolImprovement {
          // If no match, we can only safely skip one character ahead.
          i = index(after: i)
        } else {
          // Ensure to jump at least one character (this is needed because the first
          // character is in the skipTable, and `skipTable[lastChar] = 0`)
          let jumpOffset = skipTable[c] ?? patternLength
          i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
        }
      } else {
        // The characters are not equal, so skip ahead. The amount to skip is
        // determined by the skip table. If the character is not present in the
        // pattern, we can skip ahead by the full pattern length. However, if
        // the character *is* present in the pattern, there may be a match up
        // ahead and we can't skip as far.
        i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
      }
    }
    return indices
  }
}

let animals = "🐮🐶🐔🐷🐮🐮🐱🐮"
let s = "WorldHello, WorldWorld, Wordd,World"

let indices = s.indices(of: "World", usingHorspoolImprovement: true)
indices.forEach { index in
  print(s[index], terminator: " ")
}
print()

let indices1 = animals.indices(of: "🐮")
indices1.forEach { index in
    print(animals[index], terminator: " ")
}
