open class TreeNode : SyntaxTreeComponent {
  public init() { }
  public var parentPlaceholder: Placeholder!
  open func getLatexPart(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
    let errorMessage = " NotImplemented: 'getLatexPart'. "
    if MathKeyboardEngineError.shouldBeFatal {
      MathKeyboardEngineError.triggerFatalError(errorMessage, #file, #line)
    }
    return errorMessage
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
    }
    if k.current === self {
      return concatLatex([latex, latexConfiguration.activePlaceholderLatex])
    }
    return latex
  }
}
