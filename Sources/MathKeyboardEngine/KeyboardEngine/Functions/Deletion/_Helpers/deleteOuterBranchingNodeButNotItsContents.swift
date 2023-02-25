internal func deleteOuterBranchingNodeButNotItsContents(_ nonEmptyPlaceholder: Placeholder) {
  let outerBranchingNode: BranchingNode = nonEmptyPlaceholder.parentNode!
  let indexOfOuterBranchingNode: Int = outerBranchingNode.parentPlaceholder.nodes.indexOf(outerBranchingNode)!
  outerBranchingNode.parentPlaceholder.nodes.replaceSubrange(indexOfOuterBranchingNode...indexOfOuterBranchingNode, with:nonEmptyPlaceholder.nodes)
  for node: TreeNode in nonEmptyPlaceholder.nodes.asValueTypeArray {
    node.parentPlaceholder = outerBranchingNode.parentPlaceholder
  }
}
