public extension KeyboardMemory {
  func moveUp() -> Void {
    var fromPlaceholder = (self.current as? Placeholder) ?? (self.current as! TreeNode).parentPlaceholder!
    while true {
      guard let suggestingNode = fromPlaceholder.parentNode else {
        return
      }
      if let suggestion = suggestingNode.getMoveUpSuggestion(fromPlaceholder) {
        self.current = suggestion.nodes.last ?? suggestion
        return
      }
      fromPlaceholder = suggestingNode.parentPlaceholder
    }
  }
}


