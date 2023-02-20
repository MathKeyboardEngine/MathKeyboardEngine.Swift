internal func endsWithLatexCommand(_ latex: String) -> Bool {
  if latex.count == 0 {
    return false;
  }

  if latex.last!.isLetter {
    for i: Int in (0..<latex.count).reversed() {
      let c: Character = latex[i];
      if c.isLetter {
        continue;
      } else {
        return c == "\\"
      }
    }
  }
  return false;
}
