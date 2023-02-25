internal func concatLatex(_ latexArray: [String])-> String {
  var s: String = ""
  for latexToAdd in latexArray {
    if endsWithLatexCommand(s) && latexToAdd[0].isLetter {
      s += " "
    }
    s += latexToAdd
  }
  return s
}

