import MathKeyboardEngine // don't forget this import :)

internal func basicTest() {
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
    do{
      let parsedKeyboardMemory = try parseLatex("4ac")
      k.insert(parsedKeyboardMemory.syntaxTreeRoot.nodes)
    }
    catch{
      print("error")
      return
    }
    printLatex()
    k.moveDown()
    printLatex()
    k.insert(DigitNode("2"))
    printLatex()
    k.insert(StandardLeafNode("a"))
    printLatex()
    print()
    let finalText = "Quadratic formula: " + k.getViewModeLatex(latexConfiguration)
    print(finalText)
    print()
}
