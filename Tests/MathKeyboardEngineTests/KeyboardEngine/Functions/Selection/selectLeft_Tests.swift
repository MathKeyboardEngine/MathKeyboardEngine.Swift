public class SelectLeft_Tests : XCTestCase
{

    func test__Can_select_a_single_TreeNode_and_the_selection_is_correctly_displayed__case_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        Expect.latex("12▦", k)
        // Act
        k.selectLeft()
        // Assert
        Expect.latex(#"1\colorbox{blue}{2}"#, k)
    }


    func test__Can_select_a_single_TreeNode_and_the_selection_is_correctly_displayed__case_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        Expect.latex("1▦", k)
        // Act
        k.selectLeft()
        // Assert
        Expect.latex(#"\colorbox{blue}{1}"#, k)
    }


    func test__Can_select_mulitple_TreeNodes_and_the_selection_is_correctly_displayed__case_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.insert(DigitNode("3"))
        Expect.latex("123▦", k)
        // Act
        k.selectLeft()
        k.selectLeft()
        // Assert
        Expect.latex(#"1\colorbox{blue}{23}"#, k)
    }


    func test__Can_select_mulitple_TreeNodes_and_the_selection_is_correctly_displayed__case_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        Expect.latex("12▦", k)
        // Act
        k.selectLeft()
        k.selectLeft()
        // Assert
        Expect.latex(#"\colorbox{blue}{12}"#, k)
    }


    func test__Does_nothing_if_Current_is_the_SyntaxTreeRoot_and_no_SelectRight_has_been_done()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.moveLeft()
        Expect.latex("▦1", k)
        k.enterSelectionMode()
        // Act
        k.selectLeft()
        // Assert
        Expect.latex("▦1", k)
    }


    func test__Does_nothing_if_all_on_the_left_available_TreeNodes_are_selected()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.selectLeft()
        Expect.latex(#"\colorbox{blue}{1}"#, k)
        // Act
        k.selectLeft()
        // Assert
        Expect.latex(#"\colorbox{blue}{1}"#, k)
    }


    func test__Stays_in_selection_mode_after_deselecting_until_nothing_is_selected()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.moveLeft()
        k.selectRight()
        Expect.latex(#"\colorbox{blue}{1}"#, k)
        // Act
        k.selectLeft()
        // Assert
        Expect.latex("▦1", k)
        XCTAssertTrue(k.inSelectionMode())
    }


    func test__Can_break_out_of_the_current_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("2"))
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"))
        k.insert(StandardLeafNode("x"))
        Expect.latex("2^{x▦}", k)
        k.selectLeft()
        Expect.latex(#"2^{\colorbox{blue}{x}}"#, k)
        // Act
        k.selectLeft()
        // Assert
        Expect.latex(#"\colorbox{blue}{2^{x}}"#, k)
    }
}
