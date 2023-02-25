public extension KeyboardMemory {
  func getEditModeLatex(_ latexConfiguration: LatexConfiguration) -> String {
    return self.syntaxTreeRoot.getLatex(self, latexConfiguration)
  }
}