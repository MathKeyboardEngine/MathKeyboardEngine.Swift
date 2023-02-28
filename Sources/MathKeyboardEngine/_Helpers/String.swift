internal extension String {
  var length: Int {
    return count
  }

  subscript (i: Int) -> Character {
    return Character(self[i ..< i + 1])
  }

  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }
}