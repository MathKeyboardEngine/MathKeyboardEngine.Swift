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
    do {
      let (rowIndex, columnIndex ) = try self.getPositionOf(fromPlaceholder)
      if (rowIndex + 1 < self.grid.count) {
        return self.grid[rowIndex + 1][columnIndex]
      } else {
        return nil
      }
    } catch {
      return nil
    }
  }

  open override func getMoveUpSuggestion(_ fromPlaceholder: Placeholder) -> Placeholder? {
    do {
      let ( rowIndex, columnIndex ) = try self.getPositionOf(fromPlaceholder)
      if (rowIndex - 1 >= 0) {
        return self.grid[rowIndex - 1][columnIndex]
      } else {
        return nil
      }
    }
    catch {
      return nil
    }
  }

  private func getPositionOf(_ placeholder: Placeholder) throws -> (Int,Int) {    
    guard let index = self.placeholders.indexOf(placeholder) else {
      throw MathKeyboardEngineError("The provided Placeholder is not part of this MatrixNode.")
    }
    let rowIndex = index / self.width
    let columnIndex = index - rowIndex * self.width
    return (rowIndex, columnIndex)
  }
}
