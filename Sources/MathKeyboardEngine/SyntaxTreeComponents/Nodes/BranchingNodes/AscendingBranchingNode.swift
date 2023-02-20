open class AscendingBranchingNode : StandardBranchingNode {
  
  open override func getMoveDownSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    let currentPlaceholderIndex = self.placeholders.indexOf(fromPlaceholder)
    if currentPlaceholderIndex != nil && currentPlaceholderIndex! > 0 {
      return self.placeholders[currentPlaceholderIndex! - 1];
    } else {
      return nil;
    }
  }

  open override func getMoveUpSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    let currentPlaceholderIndex = self.placeholders.indexOf(fromPlaceholder)
    if currentPlaceholderIndex != nil && currentPlaceholderIndex! < self.placeholders.count - 1 {
      return self.placeholders[currentPlaceholderIndex! + 1];
    } else {
      return nil;
    }
  }
}
