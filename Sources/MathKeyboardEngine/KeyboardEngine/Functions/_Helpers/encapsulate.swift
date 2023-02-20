internal extension ReferenceArray<TreeNode> {
  func encapsulate(_ encapsulatingPlaceholder: Placeholder) -> Void {
    for node in self.asValueTypeArray {
      node.parentPlaceholder = encapsulatingPlaceholder;
      encapsulatingPlaceholder.nodes.append(node)
    }
  }
}

