open class Placeholder : SyntaxTreeComponent {
  public var parentNode: BranchingNode? = nil
  public var nodes: ReferenceArray<TreeNode> = ReferenceArray<TreeNode>()

  open override func getLatex(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
        if (self === k.inclusiveSelectionLeftBorder)
        {
            return concatLatex([latexConfiguration.selectionHightlightStart] + nodes.asValueTypeArray.map( { $0.getLatex(k, latexConfiguration) }))
        }
        else if (self === k.current)
        {
            if (nodes.count == 0)
            {
                return latexConfiguration.activePlaceholderLatex
            }
            else
            {
                return concatLatex([latexConfiguration.activePlaceholderLatex] + nodes.asValueTypeArray.map( { $0.getLatex(k, latexConfiguration) }))
            }
        }
        else if (nodes.count == 0)
        {
            return latexConfiguration.passivePlaceholderLatex
        }
        else
        {
            return concatLatex(nodes.asValueTypeArray.map({ $0.getLatex(k, latexConfiguration) }))
        }
    }
}
