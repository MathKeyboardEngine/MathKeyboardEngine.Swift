public class KeyboardMemory {
  public let syntaxTreeRoot: Placeholder = Placeholder()
  public var current: SyntaxTreeComponent
  public init() {
    current = syntaxTreeRoot
  }

  public var selectionDiff: Int?
  public var inclusiveSelectionRightBorder: TreeNode?
  public var inclusiveSelectionLeftBorder: SyntaxTreeComponent?
}
