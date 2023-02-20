public extension KeyboardMemory {
  func selectLeft() -> Void {
    let oldDiffWithCurrent = self.selectionDiff ?? 0;
    if ((self.current is TreeNode && (self.current as! TreeNode).parentPlaceholder.nodes.indexOf(self.current as! TreeNode)! + oldDiffWithCurrent >= 0) || (self.current is Placeholder && oldDiffWithCurrent > 0)) {
      self.setSelectionDiff(oldDiffWithCurrent - 1);
    } else if (
      self.inclusiveSelectionLeftBorder is TreeNode &&
      (self.inclusiveSelectionLeftBorder as! TreeNode).parentPlaceholder.nodes.indexOf(self.inclusiveSelectionLeftBorder as! TreeNode) == 0 &&
      (self.inclusiveSelectionLeftBorder as! TreeNode).parentPlaceholder.parentNode != nil
    ) {
      self.current = (self.inclusiveSelectionLeftBorder as! TreeNode).parentPlaceholder.parentNode!
      self.setSelectionDiff(-1);
    }
  }
}

