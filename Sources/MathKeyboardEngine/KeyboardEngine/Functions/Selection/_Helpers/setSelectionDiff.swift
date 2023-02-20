internal extension KeyboardMemory {
  func setSelectionDiff(_ diffWithCurrent: Int) -> Void {
    if (diffWithCurrent == 0) {
      self.inclusiveSelectionLeftBorder = nil
      self.inclusiveSelectionRightBorder = nil
    } else if let current: Placeholder = self.current as? Placeholder {
      self.inclusiveSelectionLeftBorder = current
      self.inclusiveSelectionRightBorder = current.nodes[diffWithCurrent - 1]
    } else {
      let current = self.current as! TreeNode
      let nodes : ReferenceArray<TreeNode> = current.parentPlaceholder.nodes
      let indexOfCurrent = nodes.indexOf(current)!
      if diffWithCurrent > 0 {
        self.inclusiveSelectionLeftBorder = nodes[indexOfCurrent + 1]
        self.inclusiveSelectionRightBorder = nodes[indexOfCurrent + diffWithCurrent]
      } else {
        let indexOfNewInclusiveSelectionLeftBorder: Int = indexOfCurrent + diffWithCurrent + 1
        if indexOfNewInclusiveSelectionLeftBorder < 0 {
          return
        }
        self.inclusiveSelectionLeftBorder = nodes[indexOfNewInclusiveSelectionLeftBorder]
        self.inclusiveSelectionRightBorder = (self.current as! TreeNode)
      }
    }
    self.selectionDiff = diffWithCurrent
  }
}

