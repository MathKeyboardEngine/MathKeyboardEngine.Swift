public extension KeyboardMemory {
  func deleteRight() -> Void {
    if let current: Placeholder = self.current as? Placeholder {
      if let parentNode = current.parentNode, parentNode.placeholders.asValueTypeArray.allSatisfy({ $0.nodes.isEmpty }) {
        let previousNode: TreeNode? = parentNode.parentPlaceholder.nodes.firstBeforeOrNil(parentNode)
        parentNode.parentPlaceholder.nodes.remove(parentNode)
        self.current = previousNode ?? parentNode.parentPlaceholder
      } else {
        let nodes = current.nodes
        if nodes.count > 0 {
          handleDeletion(nodes[0])
        } else if let parentNode: BranchingNode = current.parentNode {
          let siblingPlaceholders = parentNode.placeholders
          if siblingPlaceholders[0] === current && siblingPlaceholders.count == 2 {
            let nonEmptyPlaceholder: Placeholder = siblingPlaceholders[1]
            self.current = parentNode.parentPlaceholder.nodes.firstBeforeOrNil(parentNode) ?? parentNode.parentPlaceholder
            deleteOuterBranchingNodeButNotItsContents(nonEmptyPlaceholder)
          } else {
            for i in (siblingPlaceholders.indexOf(current)! + 1)..<siblingPlaceholders.count {
              if siblingPlaceholders[i].nodes.count > 0 {
                self.current = siblingPlaceholders[i]
                self.deleteRight()
                return
              }
            }
          }
        }
      }
    } else {
      let current = self.current as! TreeNode
      if let nextNode: TreeNode = current.parentPlaceholder.nodes.firstAfterOrNil(current) {
        handleDeletion(nextNode)
      }
    }
  }

  private func handleDeletion(_ nextNode_: TreeNode) -> Void {
    if let nextNode: BranchingNode = nextNode_ as? BranchingNode {
      if nextNode.placeholders.count == 1 && nextNode.placeholders[0].nodes.count > 0 {
        deleteOuterBranchingNodeButNotItsContents(nextNode.placeholders[0])
      } else if nextNode.placeholders.count == 2 && nextNode.placeholders[0].nodes.isEmpty && nextNode.placeholders[1].nodes.count > 0 {
        deleteOuterBranchingNodeButNotItsContents(nextNode.placeholders[1])
      } else {
        self.current = nextNode.placeholders[0]
        self.deleteRight()
      }
    } else {
      nextNode_.parentPlaceholder.nodes.remove(nextNode_)
    }
  }
}