public extension KeyboardMemory {
  func moveRight() -> Void {
    if let current = self.current as? Placeholder {
      if current.nodes.count > 0 {
        let nextNode = current.nodes[0]
        self.current = nextNode is BranchingNode ? (nextNode as! BranchingNode).placeholders[0] : nextNode
      } else if current.parentNode == nil {
        return
      } else {
        self.current = current.parentNode!.placeholders.firstAfterOrNil(current) ?? current.parentNode!
      }
    } else {
      let current = self.current as! TreeNode
      let nextNode = current.parentPlaceholder.nodes.firstAfterOrNil(current)
      if nextNode != nil {
        self.current = nextNode is BranchingNode ? (nextNode as! BranchingNode).placeholders[0] : nextNode!
      } else {
        let ancestorNode = current.parentPlaceholder.parentNode;
        if (ancestorNode != nil) {
          let nextPlaceholder = ancestorNode!.placeholders.firstAfterOrNil(current.parentPlaceholder)
          self.current = nextPlaceholder ?? ancestorNode!
        }
      }
    }
  }
}


