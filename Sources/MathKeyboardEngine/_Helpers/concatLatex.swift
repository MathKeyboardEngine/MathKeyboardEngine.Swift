internal func concatLatex(_ latexArray: [String])-> String {
  var s: String = ""
  for i: Int in 0..<latexArray.count {
    let latexToAdd: String = latexArray[i]
    if endsWithLatexCommand(s) && latexToAdd[0].isLetter {
      s += " "
    }
    s += latexToAdd;
  }
  return s;
}

