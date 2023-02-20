open class DigitNode : PartOfNumberWithDigits {
  private let latex: String
  public init(_ digit: String) {
    self.latex = digit
    super.init()
  }
  open override func getLatexPart(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
    return self.latex
  }
}
