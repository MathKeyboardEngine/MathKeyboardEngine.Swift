public extension KeyboardMemory {
  func moveDown() -> Void {
    var fromPlaceholder = (self.current as? Placeholder) ?? (self.current as! TreeNode).parentPlaceholder!
    while let suggestingNode = fromPlaceholder.parentNode  {
      if let suggestion = suggestingNode.getMoveDownSuggestion(fromPlaceholder) {
        self.current = suggestion.nodes.last ?? suggestion
        return
      }
      fromPlaceholder = suggestingNode.parentPlaceholder
    }
  }
}

