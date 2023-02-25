public extension KeyboardMemory {
  func moveDown() -> Void {
    var fromPlaceholder = (self.current as? Placeholder) ?? (self.current as! TreeNode).parentPlaceholder!
    while true {
      guard let suggestingNode = fromPlaceholder.parentNode else {
        return
      }
      if let suggestion = suggestingNode.getMoveDownSuggestion(fromPlaceholder) {
        self.current = suggestion.nodes.last ?? suggestion
        return
      }
      fromPlaceholder = suggestingNode.parentPlaceholder
    }
  }
}

