open class StandardBranchingNode : BranchingNode {
  private let before: String
  private let then: String
  private let rest: [String]

  public init(_ before: String, _ then: String, _ rest: String...) {
    let placeholderCount = rest.count + 1
    let placeholders = ReferenceArray<Placeholder>()
    for _ in 0..<placeholderCount {
      placeholders.append(Placeholder())
    }
    self.before = before
    self.then = then
    self.rest = rest
    super.init(placeholders)
  }

  open override func getLatexPart(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
    var latex = self.before + self.placeholders[0].getLatex(k, latexConfiguration) + self.then;
    for i in 0..<self.rest.count {
      latex += self.placeholders[i + 1].getLatex(k, latexConfiguration) + self.rest[i];
    }
    return latex;
  }
}
