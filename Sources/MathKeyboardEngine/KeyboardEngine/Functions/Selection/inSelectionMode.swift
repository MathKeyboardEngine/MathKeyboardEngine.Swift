public extension KeyboardMemory {
  func inSelectionMode() -> Bool {
    return self.selectionDiff != nil
  }
}

