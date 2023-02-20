public extension KeyboardMemory {
  func deleteLeft() -> Void {
    if let current: Placeholder = self.current as? Placeholder {
      if current.parentNode == nil || !current.nodes.isEmpty {
        return
      } else {
        let nonEmptyPlaceholderOnLeft = current.parentNode!.placeholders.getFirstNonEmptyOnLeftOf(current)
        if nonEmptyPlaceholderOnLeft != nil {
          if current.parentNode!.placeholders.count == 2 && current === current.parentNode!.placeholders[1] && current.nodes.count == 0 {
            deleteOuterBranchingNodeButNotItsContents(nonEmptyPlaceholderOnLeft!);
            self.current = nonEmptyPlaceholderOnLeft!.nodes.last!
          } else {
            nonEmptyPlaceholderOnLeft!.nodes.removeLast()
            self.current = nonEmptyPlaceholderOnLeft!.nodes.last ?? nonEmptyPlaceholderOnLeft!
          }
        } else if current.parentNode!.placeholders.asValueTypeArray.allSatisfy({ $0.nodes.isEmpty }) {
          let ancestorPlaceholder = current.parentNode!.parentPlaceholder!
          let previousNode = ancestorPlaceholder.nodes.firstBeforeOrNil(current.parentNode!)
          ancestorPlaceholder.nodes.remove(current.parentNode!)
          self.current = previousNode ?? ancestorPlaceholder
        } else if current.parentNode!.placeholders[0] === current && current.nodes.isEmpty && current.parentNode!.placeholders.contains(where: { !$0.nodes.isEmpty }) {
          let previousNode = current.parentNode!.parentPlaceholder.nodes.firstBeforeOrNil(current.parentNode!)
          if (previousNode != nil) {
            encapsulatePreviousInto(previousNode!, current)
            self.current = current.nodes.last!
          } else {
            let nonEmptySiblingPlaceholders = current.parentNode!.placeholders.asValueTypeArray.filter{ !$0.nodes.isEmpty }
            if (nonEmptySiblingPlaceholders.count == 1) {
              let nodes = nonEmptySiblingPlaceholders[0].nodes;
              let ancestorPlaceholder : Placeholder = (self.current as! Placeholder).parentNode!.parentPlaceholder!
              let indexOfParentNode : Int = ancestorPlaceholder.nodes.indexOf(current.parentNode!)!
              for node in nodes.asValueTypeArray {
                node.parentPlaceholder = ancestorPlaceholder
              }
              ancestorPlaceholder.nodes.replaceSubrange(indexOfParentNode...indexOfParentNode, with: nodes)
              self.current = nodes.last!
            }
          }
        }
      }
    } else {
      let current = self.current as! TreeNode
      let currentBranchingNode = self.current as? BranchingNode
      if current is BranchingNode && currentBranchingNode!.placeholders[0].nodes.count > 0 && currentBranchingNode!.placeholders.asValueTypeArray[1..<currentBranchingNode!.placeholders.count].allSatisfy({ $0.nodes.isEmpty }) {
        let nonEmptyPlaceholder = (self.current as! BranchingNode).placeholders[0]
        deleteOuterBranchingNodeButNotItsContents(nonEmptyPlaceholder);
        self.current = nonEmptyPlaceholder.nodes.last!
      } else if current is BranchingNode && (current as! BranchingNode).placeholders.contains(where: { $0.nodes.count > 0 }) {
        self.current = (current as! BranchingNode).placeholders.asValueTypeArray.flatMap{ $0.nodes.asValueTypeArray }.last!
        self.deleteLeft()
      } else {
        let previousNode: TreeNode? = current.parentPlaceholder.nodes.firstBeforeOrNil(current)
        current.parentPlaceholder.nodes.remove(current)
        self.current = previousNode ?? current.parentPlaceholder;
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

