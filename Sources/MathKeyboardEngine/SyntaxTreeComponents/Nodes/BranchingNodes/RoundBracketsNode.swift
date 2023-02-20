open class RoundBracketsNode : StandardBranchingNode {
  public init(_ leftBracketLatex: String = #"\left("#, _ rightBracketLatex: String = #"\right)"#) {
    super.init(leftBracketLatex, rightBracketLatex)
  }
}
