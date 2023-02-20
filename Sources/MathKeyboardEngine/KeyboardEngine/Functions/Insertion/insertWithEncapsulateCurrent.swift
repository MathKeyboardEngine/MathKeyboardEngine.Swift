public extension KeyboardMemory {
  func insertWithEncapsulateCurrent(_ newNode: BranchingNode, deleteOuterRoundBracketsIfAny: Bool = false) -> Void {
    let encapsulatingPlaceholder = newNode.placeholders[0]
    if let current = self.current as? TreeNode {
      let siblingNodes : ReferenceArray<TreeNode> = current.parentPlaceholder.nodes
      let currentIndex = siblingNodes.indexOf(current)!
      siblingNodes[currentIndex] = newNode
      newNode.parentPlaceholder = current.parentPlaceholder
      if current is RoundBracketsNode && deleteOuterRoundBracketsIfAny {
        (current as! RoundBracketsNode).placeholders[0].nodes.encapsulate(encapsulatingPlaceholder)
        self.current = newNode.placeholders.firstAfterOrNil(encapsulatingPlaceholder) ?? newNode
      } else if current is PartOfNumberWithDigits {
        encapsulatingPlaceholder.nodes.append(current)
        current.parentPlaceholder = encapsulatingPlaceholder
        encapsulateAllPartsOfNumberWithDigitsLeftOfIndex(currentIndex, siblingNodes, encapsulatingPlaceholder);
        self.moveRight()
      } else {
        encapsulatingPlaceholder.nodes.append(current)
        current.parentPlaceholder = encapsulatingPlaceholder
        self.moveRight()
      }
    } else {
      self.insert(newNode)
    }
  }
}
