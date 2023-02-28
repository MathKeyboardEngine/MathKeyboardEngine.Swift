class GetLatex_Tests : XCTestCase {
    let Config : LatexConfiguration = {
        let config = LatexConfiguration()
        config.activePlaceholderShape = "▦"
        config.passivePlaceholderShape = "⬚"
        return config
    }()

    func test__Can_get_the_LaTeX_for_a_BranchingNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        // Act & Assert
        XCTAssertEqual(#"\frac{▦}{⬚}"#, k.getEditModeLatex(Config))
        XCTAssertEqual(#"\frac{⬚}{⬚}"#, k.getViewModeLatex(Config))
        XCTAssertEqual(#"\frac{⬚}{⬚}"#, DescendingBranchingNode(#"\frac{"#, "}{", "}").getViewModeLatex(Config))
    }

    func test__Can_get_the_LaTeX_for_a_LeafNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("3"))
        // Act & Assert
        XCTAssertEqual("3▦", k.getEditModeLatex(Config))
        XCTAssertEqual("3", k.getViewModeLatex(Config))
        XCTAssertEqual("3", DigitNode("3").getViewModeLatex(Config))
    }

    func test__Can_get_the_LaTeX_for_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        let fraction = DescendingBranchingNode(#"\frac{"#, "}{", "}")
        k.insert(fraction)
        k.insert(DigitNode("3"))
        k.moveDown()
        // Act & Assert
        XCTAssertEqual(#"\frac{3}{▦}"#, k.getEditModeLatex(Config))
        XCTAssertEqual(#"\frac{3}{⬚}"#, k.getViewModeLatex(Config))
        XCTAssertEqual("3", fraction.placeholders[0].getViewModeLatex(Config))
    }
}
