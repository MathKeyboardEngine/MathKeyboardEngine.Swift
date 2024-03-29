﻿public class BracePairContent {
  public init(content: String, rest : String) {
    self.content = content
    self.rest = rest
  }
  public var content : String
  public var rest : String
}

public extension String {
  func getBracketPairContent(_ opening : String, _ closing : String) throws -> BracePairContent {
    let sWithOpening : String = self
    let openingBracket = opening.last! as Character
    let toIgnores = [#"\"# + String(openingBracket), #"\"# + closing, #"\left"# + String(openingBracket), #"\right"# + closing]
    let s = String(sWithOpening[opening.count...])
    var level = 0
    var closingBracketIndex = 0
    while closingBracketIndex < s.count {
      if s[closingBracketIndex...(closingBracketIndex + closing.count - 1)] == closing {
        if level == 0 {
          return BracePairContent(content: s[0...(closingBracketIndex - 1)], rest: s[(closingBracketIndex + closing.count)...])
        } else {
          level -= 1
          closingBracketIndex += 1
          continue;
        }
      }

      let currentPosition = s[closingBracketIndex...]
      for toIgnore in toIgnores {
        if currentPosition.count >= toIgnore.count && currentPosition.starts(with: toIgnore) {
          closingBracketIndex += toIgnore.count;
          continue;
        }
      }

      if s[closingBracketIndex] == openingBracket {
        level += 1
      }

      closingBracketIndex += 1
    }
    throw MathKeyboardEngineError("A closing \(closing) is missing.")
  }
}
