import Foundation

internal extension String {
  subscript (i: Int) -> Character {
    return Character(self[i ..< i + 1])
  }

  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }

  subscript(range: ClosedRange<Int>) -> String {
    let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
    return String(self[startIndex..<index(startIndex, offsetBy: range.count)])
  }

  subscript(range: PartialRangeFrom<Int>) -> String { String(self[index(startIndex, offsetBy: range.lowerBound)...]) }
  subscript(range: PartialRangeThrough<Int>) -> String { String(self[...index(startIndex, offsetBy: range.upperBound)]) }
  // subscript(range: PartialRangeUpTo<Int>) -> String { String(self[..<index(startIndex, offsetBy: range.upperBound)]) }

  func index(of string: String) -> Index? {
    range(of: string)?.lowerBound
  }

  func byteIndex(of string: String) -> Int? {
    let index = self.index(of: string)
    if index == nil {
      return nil
    }
    return self.distance(from: self.startIndex, to: index!)
  }
}