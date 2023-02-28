open class MatrixNode : BranchingNode {
  private let matrixType: String
  private var grid: ReferenceArray<ReferenceArray<Placeholder>>
  private let width: Int
  public init(matrixType: String, width: Int, height: Int) {
    let grid = ReferenceArray<ReferenceArray<Placeholder>>()
    let leftToRight = ReferenceArray<Placeholder>()
    for _ in 0..<height {
      let row = ReferenceArray<Placeholder>()
      for _ in 0..<width {
        let placeholder = Placeholder()
        row.append(placeholder)
        leftToRight.append(placeholder)
      }
      grid.append(row)
    }
    self.grid = grid
    self.matrixType = matrixType
    self.width = width
    super.init(leftToRight)
  }

  open override func getLatexPart(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
    var latex = #"\begin{\#(self.matrixType)}"#
    latex += self.grid.asValueTypeArray.map{ $0.asValueTypeArray.map{ $0.getLatex(k, latexConfiguration)}.joined(separator:" & ")}.joined(separator: #" \\ "#)
    latex += #"\end{\#(self.matrixType)}"#
    return latex
  }

  open override func getMoveDownSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    guard let (rowIndex, columnIndex ) = self.getPositionOf(fromPlaceholder), rowIndex + 1 < self.grid.count else {
      return nil
    }
    return self.grid[rowIndex + 1][columnIndex]
  }

  open override func getMoveUpSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
      guard let ( rowIndex, columnIndex ) = getPositionOf(fromPlaceholder), rowIndex - 1 >= 0 else {
        return nil
      }
      return self.grid[rowIndex - 1][columnIndex]
  }

  private func getPositionOf(_ placeholder: Placeholder) -> (Int,Int)? {
    guard let index = self.placeholders.indexOf(placeholder) else {
      if MathKeyboardEngineError.shouldBeFatal {
        MathKeyboardEngineError.triggerFatalError("The provided Placeholder is not part of this MatrixNode.", #file, #line)
      }
      return nil
    }
    let rowIndex = index / self.width
    let columnIndex = index - rowIndex * self.width
    return (rowIndex, columnIndex)
  }
}
