open class DescendingBranchingNode : StandardBranchingNode {
  open override func getMoveDownSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    guard let currentPlaceholderIndex = self.placeholders.indexOf(fromPlaceholder), currentPlaceholderIndex < self.placeholders.count - 1 else{
      return nil
    }
    return self.placeholders[currentPlaceholderIndex + 1]
  }

  open override func getMoveUpSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    guard let currentPlaceholderIndex = self.placeholders.indexOf(fromPlaceholder), currentPlaceholderIndex > 0 else {
      return nil
    }
    return self.placeholders[currentPlaceholderIndex - 1]
  }
}
