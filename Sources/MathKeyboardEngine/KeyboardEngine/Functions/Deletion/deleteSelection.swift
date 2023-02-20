public extension KeyboardMemory {
  func deleteSelection() -> Void {
    _ = self.popSelection()
  }
}
