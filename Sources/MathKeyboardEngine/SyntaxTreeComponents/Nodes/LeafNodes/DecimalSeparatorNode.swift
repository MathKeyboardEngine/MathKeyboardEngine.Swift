open class DecimalSeparatorNode : PartOfNumberWithDigits {
  private let latex: () -> String
  public override init() {
    self.latex = { return "." }
    super.init()
  }
  public init(_ latex: String) {
    self.latex = { return latex }
    super.init()
  }
  public init(_ latex: @escaping () -> String) {
    self.latex = latex
    super.init()
  }

  open override func getLatexPart(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
    return self.latex()
  }
}
