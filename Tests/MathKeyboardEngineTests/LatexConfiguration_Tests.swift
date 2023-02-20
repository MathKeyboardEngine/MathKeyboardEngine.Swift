class LatexConfiguration_Tests : XCTestCase
{
    func test__Allow_customizing_the_shape_of_the_cursor_and_empty_Placeholders()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        let myLatexConfiguration = LatexConfiguration()
        
        // Act
        myLatexConfiguration.activePlaceholderShape = "myCursor"
        myLatexConfiguration.passivePlaceholderShape = "myEmptyPlace"
        
        // Assert
        XCTAssertEqual("myCursor^{myEmptyPlace}", k.getEditModeLatex(myLatexConfiguration))
    }

    func test__Allows_customizing_the_color_of_the_cursor_and_Placeholders()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        let myLatexConfiguration = LatexConfiguration()
        myLatexConfiguration.activePlaceholderShape = #"\blacksquare"#
        myLatexConfiguration.passivePlaceholderShape = #"\blacksquare"#

        // Act
        myLatexConfiguration.activePlaceholderColor = "orange"
        myLatexConfiguration.passivePlaceholderColor = "gray"
        
        // Assert
        XCTAssertEqual(#"{\color{orange}\blacksquare}^{{\color{gray}\blacksquare}}"#, k.getEditModeLatex(myLatexConfiguration))
    }
}
