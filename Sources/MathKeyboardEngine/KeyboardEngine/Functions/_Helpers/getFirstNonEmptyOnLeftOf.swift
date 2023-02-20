internal extension ReferenceArray<Placeholder> {
  func getFirstNonEmptyOnLeftOf(_ element: Placeholder) -> Placeholder? {
    var isOnTheLeft = false
    for i in (0..<self.count).reversed() {
      let placeholder: Placeholder = self[i]
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


