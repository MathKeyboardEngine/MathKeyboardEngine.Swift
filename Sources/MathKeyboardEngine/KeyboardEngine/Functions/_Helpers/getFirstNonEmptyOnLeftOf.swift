internal extension ReferenceArray<Placeholder> {
  func getFirstNonEmptyOnLeftOf(_ element: Placeholder) -> Placeholder? {
    var isOnTheLeft = false
    for placeholder in self.asValueTypeArray.reversed() {
      if !isOnTheLeft {
        if placeholder === element {
          isOnTheLeft = true
        }
        continue
      }

      if placeholder.nodes.count > 0 {
        return placeholder
      }
    }
    return nil
  }
}


