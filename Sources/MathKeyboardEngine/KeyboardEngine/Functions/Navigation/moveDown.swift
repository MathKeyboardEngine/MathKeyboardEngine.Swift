public extension KeyboardMemory {
  func moveDown() -> Void {
    var fromPlaceholder = (self.current is Placeholder ? self.current : (self.current as! TreeNode).parentPlaceholder) as! Placeholder
    var suggestingNode: BranchingNode
    while (true) {
      if fromPlaceholder.parentNode == nil {
        return
      }
      suggestingNode = fromPlaceholder.parentNode!
      let suggestion = suggestingNode.getMoveDownSuggestion(fromPlaceholder)
      if (suggestion != nil) {
        self.current = suggestion!.nodes.last ?? suggestion!
        return
      }
      fromPlaceholder = suggestingNode.parentPlaceholder
    }
  }
}

