public extension KeyboardMemory {
  func moveRight() -> Void {
    if let current = self.current as? Placeholder {
      if current.nodes.count > 0 {
        let nextNode = current.nodes[0]
        self.current = (nextNode as? BranchingNode)?.placeholders[0] ?? nextNode
      } else {
        guard let parentNode = current.parentNode else {
          return
        }
        self.current = parentNode.placeholders.firstAfterOrNil(current) ?? parentNode
      }
    } else {
      let current = self.current as! TreeNode
      if let nextNode = current.parentPlaceholder.nodes.firstAfterOrNil(current) {
        self.current = (nextNode as? BranchingNode)?.placeholders[0] ?? nextNode
      } else {
        if let ancestorNode = current.parentPlaceholder.parentNode {
          let nextPlaceholder = ancestorNode.placeholders.firstAfterOrNil(current.parentPlaceholder)
          self.current = nextPlaceholder ?? ancestorNode
        }
      }
    }
  }
}


