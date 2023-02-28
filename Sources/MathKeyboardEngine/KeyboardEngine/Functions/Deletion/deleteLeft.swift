public extension KeyboardMemory {
  func deleteLeft() -> Void {
    if let current: Placeholder = self.current as? Placeholder {
      guard current.nodes.isEmpty, let currentParentNode : BranchingNode = current.parentNode else {
        return
      }
      if let nonEmptyPlaceholderOnLeft = currentParentNode.placeholders.getFirstNonEmptyOnLeftOf(current) {
        if currentParentNode.placeholders.count == 2 && current === currentParentNode.placeholders[1] && current.nodes.count == 0 {
          deleteOuterBranchingNodeButNotItsContents(nonEmptyPlaceholderOnLeft)
          self.current = nonEmptyPlaceholderOnLeft.nodes.last!
        } else {
          nonEmptyPlaceholderOnLeft.nodes.removeLast()
          self.current = nonEmptyPlaceholderOnLeft.nodes.last ?? nonEmptyPlaceholderOnLeft
        }
      } else if currentParentNode.placeholders.asValueTypeArray.allSatisfy({ $0.nodes.isEmpty }) {
        let ancestorPlaceholder = currentParentNode.parentPlaceholder!
        let previousNode = ancestorPlaceholder.nodes.firstBeforeOrNil(currentParentNode)
        ancestorPlaceholder.nodes.remove(currentParentNode)
        self.current = previousNode ?? ancestorPlaceholder
      } else if currentParentNode.placeholders[0] === current && current.nodes.isEmpty && currentParentNode.placeholders.contains(where: { $0.nodes.count > 0 }) {
        if let previousNode = currentParentNode.parentPlaceholder.nodes.firstBeforeOrNil(currentParentNode) {
          encapsulatePreviousInto(previousNode, current)
          self.current = current.nodes.last!
        } else {
          let nonEmptySiblingPlaceholders = currentParentNode.placeholders.asValueTypeArray.filter{ $0.nodes.count > 0 }
          if (nonEmptySiblingPlaceholders.count == 1) {
            let nodes = nonEmptySiblingPlaceholders[0].nodes
            let ancestorPlaceholder : Placeholder = currentParentNode.parentPlaceholder!
            let indexOfParentNode : Int = ancestorPlaceholder.nodes.indexOf(currentParentNode)!
            for node in nodes.asValueTypeArray {
              node.parentPlaceholder = ancestorPlaceholder
            }
            ancestorPlaceholder.nodes.replaceSubrange(indexOfParentNode...indexOfParentNode, with: nodes)
            self.current = nodes.last!
          }
        }
      }
    } else {
      if let current = self.current as? BranchingNode, current.placeholders[0].nodes.count > 0 && current.placeholders.asValueTypeArray[1..<current.placeholders.count].allSatisfy({ $0.nodes.isEmpty }) {
        let nonEmptyPlaceholder = current.placeholders[0]
        deleteOuterBranchingNodeButNotItsContents(nonEmptyPlaceholder)
        self.current = nonEmptyPlaceholder.nodes.last!
      } else if let current = self.current as? BranchingNode, current.placeholders.contains(where: { $0.nodes.count > 0 }) {
        self.current = current.placeholders.asValueTypeArray.flatMap{ $0.nodes.asValueTypeArray }.last!
        self.deleteLeft()
      } else {
        let current = self.current as! TreeNode
        let previousNode: TreeNode? = current.parentPlaceholder.nodes.firstBeforeOrNil(current)
        current.parentPlaceholder.nodes.remove(current)
        self.current = previousNode ?? current.parentPlaceholder
      }
    }
  }

  func encapsulatePreviousInto(_ previousNode: TreeNode, _ targetPlaceholder: Placeholder) {
    targetPlaceholder.parentNode!.parentPlaceholder.nodes.remove(previousNode)
    targetPlaceholder.nodes.append(previousNode)
    let previousNodeOldParentPlaceholder : Placeholder = previousNode.parentPlaceholder!
    previousNode.parentPlaceholder = targetPlaceholder
    if previousNode is PartOfNumberWithDigits {
      encapsulateAllPartsOfNumberWithDigitsLeftOfIndex(previousNodeOldParentPlaceholder.nodes.count - 1, previousNodeOldParentPlaceholder.nodes, targetPlaceholder)
    }
  }
}

