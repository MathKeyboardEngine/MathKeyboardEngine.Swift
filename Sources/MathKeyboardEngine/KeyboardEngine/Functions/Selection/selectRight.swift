public extension KeyboardMemory {
  func selectRight() -> Void {
    let oldDiffWithCurrent: Int = self.selectionDiff ?? 0
    if
      (self.current is Placeholder && oldDiffWithCurrent < (self.current as! Placeholder).nodes.count) ||
      (self.current is TreeNode && (self.current as! TreeNode).parentPlaceholder.nodes.indexOf(self.current as! TreeNode)! + oldDiffWithCurrent < (self.current as! TreeNode).parentPlaceholder.nodes.count - 1)
    {
      self.setSelectionDiff(oldDiffWithCurrent + 1)
    } else if 
      let rightBorder = self.inclusiveSelectionRightBorder,
      rightBorder.parentPlaceholder.nodes.last! === rightBorder,
      let ancestorNode = rightBorder.parentPlaceholder.parentNode
     {
      self.current = ancestorNode.parentPlaceholder.nodes.firstBeforeOrNil(ancestorNode) ?? ancestorNode.parentPlaceholder
      self.setSelectionDiff(1)
    }
  }
}

