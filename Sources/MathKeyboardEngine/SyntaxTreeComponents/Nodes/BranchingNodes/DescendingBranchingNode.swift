open class DescendingBranchingNode : StandardBranchingNode {
  open override func getMoveDownSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    if let currentPlaceholderIndex = self.placeholders.indexOf(fromPlaceholder), currentPlaceholderIndex < self.placeholders.count - 1 {
      return self.placeholders[currentPlaceholderIndex + 1]
    } else {
      return nil
    }
  }

  open override func getMoveUpSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    if let currentPlaceholderIndex = self.placeholders.indexOf(fromPlaceholder), currentPlaceholderIndex > 0 {
      return self.placeholders[currentPlaceholderIndex - 1]
    } else {
      return nil
    }
  }
}
