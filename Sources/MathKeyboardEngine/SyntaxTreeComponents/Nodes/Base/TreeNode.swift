open class TreeNode : SyntaxTreeComponent {
  public var parentPlaceholder: Placeholder!
  open func getLatexPart(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String { 
    return "error"
  }
  open func getLatex(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
    var latex = self.getLatexPart(k, latexConfiguration)
    if k.selectionDiff != nil && k.selectionDiff != 0 {
      if (k.inclusiveSelectionLeftBorder === self) {
        latex = concatLatex([latexConfiguration.selectionHightlightStart, latex])
      }
      if (k.inclusiveSelectionRightBorder === self) {
        latex = concatLatex([latex, latexConfiguration.selectionHightlightEnd])
      }
      return latex
    } else {
      if (k.current === self) {
        return concatLatex([latex, latexConfiguration.activePlaceholderLatex])
      } else {
        return latex
      }
    }
  }
}
