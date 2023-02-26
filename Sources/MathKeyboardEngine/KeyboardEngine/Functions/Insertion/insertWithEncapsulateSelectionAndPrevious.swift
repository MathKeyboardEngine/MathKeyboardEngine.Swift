public extension KeyboardMemory {
  func insertWithEncapsulateSelectionAndPrevious(_ newNode: BranchingNode) -> Void {
    if newNode.placeholders.count < 2 {
      if MathKeyboardEngineError.shouldBeFatal {
        MathKeyboardEngineError.triggerFatalError("Expected 2 placeholders.", #file, #line)
      }
      return
    }
    let selection: ReferenceArray<TreeNode> = self.popSelection()
    let secondPlaceholder: Placeholder = newNode.placeholders[1]
    selection.encapsulate(secondPlaceholder)
    self.insertWithEncapsulateCurrent(newNode)
    self.current = selection.last ?? secondPlaceholder
  }
}

