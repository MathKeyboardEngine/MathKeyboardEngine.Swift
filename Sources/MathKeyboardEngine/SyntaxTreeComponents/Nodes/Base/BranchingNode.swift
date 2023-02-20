open class BranchingNode : TreeNode {
  public let placeholders: ReferenceArray<Placeholder>

  public init(_ leftToRight: ReferenceArray<Placeholder>) {
    self.placeholders = leftToRight;
    super.init()
    for ph in self.placeholders.asValueTypeArray {
      ph.parentNode = self;
    }
  }

  open func getMoveDownSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    return nil
  }

  open func getMoveUpSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    return nil
  }
}
