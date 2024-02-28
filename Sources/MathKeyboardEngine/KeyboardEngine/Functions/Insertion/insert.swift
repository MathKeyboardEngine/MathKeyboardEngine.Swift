public extension KeyboardMemory {
func insert(_ nodes : ReferenceArray<TreeNode>) {
    insert(nodes.asValueTypeArray)
  }

  func insert(_ nodes : Array<TreeNode>) {
    for node in nodes {
      self.insertCore(node)
      self.current = node
    }
  }

  func insert(_ newNode : TreeNode) {
    self.insertCore(newNode)
    self.moveRight()
  }

  func insertCore(_ newNode: TreeNode) -> Void {
    if let current = self.current as? Placeholder  {
      current.nodes.insert(newNode, at: 0)
      newNode.parentPlaceholder = current
    } else {
      let current = self.current as! TreeNode
      let parent: Placeholder = current.parentPlaceholder
      let indexOfCurrent = parent.nodes.indexOf(current)!
      parent.nodes.insert(newNode, at: indexOfCurrent + 1)
      newNode.parentPlaceholder = parent
    }
  }
}

