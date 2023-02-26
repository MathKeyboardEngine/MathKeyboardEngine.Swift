internal extension KeyboardMemory {
  func popSelection() -> ReferenceArray<TreeNode> {
    guard let diff = self.selectionDiff else {
      if MathKeyboardEngineError.shouldBeFatal {
        MathKeyboardEngineError.triggerFatalError("Enter selection mode before calling this method.", #file, #line)
      }
      return ReferenceArray<TreeNode>()
    }
    if diff == 0 {
      self.leaveSelectionMode()
      return ReferenceArray<TreeNode>()
    }
    if let current: Placeholder = self.current as? Placeholder {
      self.leaveSelectionMode()
      return current.nodes.removeRange(start: 0, exclusiveEnd: diff)
    }
    let current: TreeNode = self.current as! TreeNode
    let siblings = current.parentPlaceholder.nodes
    let inclusiveSelectionLeftBorder = self.inclusiveSelectionLeftBorder as! TreeNode
    let indexOfLeftBorder: Int = siblings.indexOf(inclusiveSelectionLeftBorder)!
    self.current = siblings.firstBeforeOrNil(inclusiveSelectionLeftBorder) ?? current.parentPlaceholder!
    self.leaveSelectionMode()
    return siblings.removeRange(start:indexOfLeftBorder, exclusiveEnd: (indexOfLeftBorder + abs(diff)))
  }

  private func abs(_ n: Int) -> Int {
    return n < 0 ? -n : n
  }
}
