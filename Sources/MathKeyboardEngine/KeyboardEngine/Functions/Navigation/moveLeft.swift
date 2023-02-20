public extension KeyboardMemory {
  func moveLeft() -> Void {
    if let current = self.current as? Placeholder {
      if current.parentNode == nil {
        return;
      }

      let previousPlaceholder = current.parentNode!.placeholders.firstBeforeOrNil(current)
      if previousPlaceholder != nil {
        self.current = previousPlaceholder!.nodes.last ?? previousPlaceholder!
      } else {
        let ancestorPlaceholder = current.parentNode!.parentPlaceholder!
        let nodePreviousToParentOfCurrent = ancestorPlaceholder.nodes.firstBeforeOrNil(current.parentNode!)
        self.current = nodePreviousToParentOfCurrent ?? ancestorPlaceholder
      }
    } else {
      if let current = self.current as? BranchingNode {
        let placeholder = current.placeholders.last!
        self.current = placeholder.nodes.last ?? placeholder
      } else {
        let current = self.current as! TreeNode
        self.current = current.parentPlaceholder.nodes.firstBeforeOrNil(current) ?? current.parentPlaceholder
      }
    }
  }
}
