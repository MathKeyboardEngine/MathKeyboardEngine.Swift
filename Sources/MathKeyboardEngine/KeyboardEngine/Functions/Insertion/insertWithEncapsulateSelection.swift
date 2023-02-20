public extension KeyboardMemory {
  func insertWithEncapsulateSelection(_ newNode: BranchingNode) -> Void {
    let selection = self.popSelection()
    self.insert(newNode)
    if selection.count > 0 {
      let encapsulatingPlaceholder = newNode.placeholders[0]
      selection.encapsulate(encapsulatingPlaceholder)
      self.current = selection.last!
      self.moveRight()
    }
  }
}