public extension KeyboardMemory {
  func selectLeft() -> Void {
    let oldDiffWithCurrent = self.selectionDiff ?? 0
    if 
      (self.current is TreeNode && (self.current as! TreeNode).parentPlaceholder.nodes.indexOf(self.current as! TreeNode)! + oldDiffWithCurrent >= 0) || 
      (self.current is Placeholder && oldDiffWithCurrent > 0) 
    {
      self.setSelectionDiff(oldDiffWithCurrent - 1)
    } else if 
      let inclusiveSelectionLeftBorder = self.inclusiveSelectionLeftBorder as? TreeNode,
      inclusiveSelectionLeftBorder.parentPlaceholder.nodes.indexOf(inclusiveSelectionLeftBorder) == 0,
      let leftBorderAncestorNode = inclusiveSelectionLeftBorder.parentPlaceholder.parentNode
     {
      self.current = leftBorderAncestorNode
      self.setSelectionDiff(-1)
    }
  }
}

