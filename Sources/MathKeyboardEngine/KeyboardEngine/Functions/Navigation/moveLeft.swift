public extension KeyboardMemory {
  func moveLeft() -> Void {
    if let current = self.current as? Placeholder {
      guard let parentNode = current.parentNode else {
        return
      }

      if let previousPlaceholder = parentNode.placeholders.firstBeforeOrNil(current) {
        self.current = previousPlaceholder.nodes.last ?? previousPlaceholder
      } else {
        let ancestorPlaceholder = parentNode.parentPlaceholder!
        let nodePreviousToParentOfCurrent = ancestorPlaceholder.nodes.firstBeforeOrNil(parentNode)
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
