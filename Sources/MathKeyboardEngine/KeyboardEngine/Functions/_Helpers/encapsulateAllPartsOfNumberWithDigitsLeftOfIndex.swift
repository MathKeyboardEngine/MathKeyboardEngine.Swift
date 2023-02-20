internal func encapsulateAllPartsOfNumberWithDigitsLeftOfIndex(_ exclusiveRightIndex: Int, _ siblingNodes: ReferenceArray<TreeNode>, _ toPlaceholder: Placeholder) -> Void {
  for i in (0..<exclusiveRightIndex).reversed() {
    if let siblingNode = siblingNodes[i] as? PartOfNumberWithDigits {
      siblingNodes.remove(siblingNode)
      toPlaceholder.nodes.insert(siblingNode, at: 0)
      siblingNode.parentPlaceholder = toPlaceholder
    } else {
      break
    }
  }
}
