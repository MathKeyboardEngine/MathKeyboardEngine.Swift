internal func endsWithLatexCommand(_ latex: String) -> Bool {
  if latex.isEmpty {
    return false
  }

  if latex.last!.isLetter {
    for c: Character in latex.reversed() {
      if c.isLetter {
        continue
      }
      return c == "\\"
    }
  }
  return false
}
