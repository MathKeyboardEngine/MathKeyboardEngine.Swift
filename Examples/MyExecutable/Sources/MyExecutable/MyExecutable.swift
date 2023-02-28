import MathKeyboardEngine // don't forget this import :)

@main
public struct MyExecutable {
  public static var finalText : String = "" // for unit testing this example. Fails on Windows, see issue https://github.com/apple/swift-package-manager/issues/6083

  public static func main() {
    let k = KeyboardMemory()
    let latexConfiguration = LatexConfiguration()

    // This example does not listen to key press events and does not do any typesetting:
    // it just proves that adding MathKeyboardEngine as a dependency can work.

    latexConfiguration.activePlaceholderShape = "▪"
    let printLatex = { print(k.getEditModeLatex(latexConfiguration)) }
    printLatex()
    k.insert(StandardLeafNode("x"))
    printLatex()
    k.insert(StandardLeafNode("="))
    printLatex()
    k.insert(DescendingBranchingNode(#"\frac{"#, "}{","}"))
    printLatex()
    k.insert(StandardLeafNode("-"))
    printLatex()
    k.insert(StandardLeafNode("b"))
    printLatex()
    k.insert(StandardLeafNode(#"\pm"#))
    printLatex()
    k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
    printLatex()
    k.insert(StandardLeafNode("b"))
    printLatex()
    k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"))
    printLatex()
    k.insert(DigitNode("2"))
    printLatex()
    k.moveRight()
    printLatex()
    k.insert(StandardLeafNode("-"))
    printLatex()
    k.insert(DigitNode("4"))
    printLatex()
    k.insert(StandardLeafNode("a"))
    printLatex()
    k.insert(StandardLeafNode("c"))
    printLatex()
    k.moveDown()
    printLatex()
    k.insert(DigitNode("2"))
    printLatex()
    k.insert(StandardLeafNode("a"))
    printLatex()
    print()
    finalText = "Quadratic formula: " + k.getViewModeLatex(latexConfiguration)
    print(finalText)
    print()
  }
}
