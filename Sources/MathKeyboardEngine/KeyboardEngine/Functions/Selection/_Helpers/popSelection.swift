internal extension KeyboardMemory {
  func popSelection() -> ReferenceArray<TreeNode> {
    if (self.selectionDiff == nil) {
      return ReferenceArray<TreeNode>()
    }
    if self.selectionDiff == 0 {
      self.leaveSelectionMode()
      return ReferenceArray<TreeNode>()
    }
    let diff: Int = self.selectionDiff!
    if let current: Placeholder = self.current as? Placeholder {
      self.leaveSelectionMode()
      return current.nodes.removeRange(start: 0, exclusiveEnd: diff)
    } else {
      let current: TreeNode = self.current as! TreeNode
      let siblings = current.parentPlaceholder.nodes
      let indexOfLeftBorder: Int = siblings.indexOf(self.inclusiveSelectionLeftBorder as! TreeNode)!
      self.current = siblings.firstBeforeOrNil(self.inclusiveSelectionLeftBorder as! TreeNode) ?? current.parentPlaceholder!
      self.leaveSelectionMode()
      return siblings.removeRange(start:indexOfLeftBorder, exclusiveEnd: (indexOfLeftBorder + abs(diff)))
    }
  }

  private func abs(_ n: Int) -> Int {
    return n < 0 ? -n : n
  }
}
