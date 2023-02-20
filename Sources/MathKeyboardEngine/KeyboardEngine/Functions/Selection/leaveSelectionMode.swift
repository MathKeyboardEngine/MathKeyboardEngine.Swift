public extension KeyboardMemory{
  func leaveSelectionMode() -> Void {
    self.selectionDiff = nil
    self.inclusiveSelectionRightBorder = nil
    self.inclusiveSelectionLeftBorder = nil
  }
}

