let emptyKeyboardMemory = KeyboardMemory()

public extension SyntaxTreeComponent{
  func getViewModeLatex(_ latexConfiguration: LatexConfiguration) -> String {
    return self.getLatex(emptyKeyboardMemory, latexConfiguration)
  }
}

public extension KeyboardMemory {
  func getViewModeLatex(_ latexConfiguration: LatexConfiguration) -> String {
    return self.syntaxTreeRoot.getLatex(emptyKeyboardMemory, latexConfiguration)
  }
}