class SelectRight_Tests : XCTestCase
{

    func test__Can_select_a_single_TreeNode_and_the_selection_is_correctly_displayed__case__the_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.moveLeft();
        Expect.latex("1▦2", k);
        // Act
        k.selectRight();
        // Assert
        Expect.latex(#"1\colorbox{blue}{2}"#, k);
    }


    func test__Can_select_a_single_TreeNode_and_the_selection_is_correctly_displayed__case__the_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.moveLeft();
        Expect.latex("▦1", k);
        // Act
        k.selectRight();
        // Assert
        Expect.latex(#"\colorbox{blue}{1}"#, k);
    }


    func test__Can_select_multiple_TreeNodes_and_the_selection_is_correctly_displayed__case__the_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.insert(DigitNode("3"));
        k.moveLeft();
        k.moveLeft();
        Expect.latex("1▦23", k);
        // Act
        k.selectRight();
        k.selectRight();
        // Assert
        Expect.latex(#"1\colorbox{blue}{23}"#, k);
    }


    func test__Can_select_multiple_TreeNodes_and_the_selection_is_correctly_displayed__case__the_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.moveLeft();
        k.moveLeft();
        Expect.latex("▦12", k);
        // Act
        k.selectRight();
        k.selectRight();
        // Assert
        Expect.latex(#"\colorbox{blue}{12}"#, k);
    }


    func test__Stays_in_selection_mode_after_deselecting()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.selectLeft();
        Expect.latex(#"\colorbox{blue}{1}"#, k);
        // Act
        k.selectRight();
        // Assert
        Expect.latex("1▦", k);
        XCTAssertTrue(k.inSelectionMode());
    }


    func test__Does_nothing_if_all_on_the_right_available_TreeNodes_are_selected__case_the_exclusive_left_border_is_the_SyntaxTreeRoot()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.moveLeft();
        Expect.latex("▦1", k);
        k.selectRight();
        Expect.latex(#"\colorbox{blue}{1}"#, k);
        // Act
        k.selectRight();
        // Assert
        Expect.latex(#"\colorbox{blue}{1}"#, k);
    }


    func test__Does_nothing_if_all_on_the_right_available_TreeNodes_are_selected__case_the_exclusive_left_border_is_a_TreeNode_and_its_Parent_is_the_SyntaxTreeRoot()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.moveLeft();
        Expect.latex("1▦2", k);
        k.selectRight();
        Expect.latex(#"1\colorbox{blue}{2}"#, k);
        // Act
        k.selectRight();
        // Assert
        Expect.latex(#"1\colorbox{blue}{2}"#, k);
    }


    func test__Can_break_out_of_the_current_Placeholder__case_Set_a_Placeholder_as_the_new_Current()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"));
        k.insert(DigitNode("2"));
        k.moveRight();
        k.insert(StandardLeafNode("+"));
        k.insert(DigitNode("a"));
        k.moveLeft();
        k.moveLeft();
        k.moveLeft();
        k.moveLeft();
        Expect.latex(#"\sqrt{▦2}+a"#, k);
        k.selectRight();
        Expect.latex(#"\sqrt{\colorbox{blue}{2}}+a"#, k);
        // Act & Assert
        k.selectRight();
        Expect.latex(#"\colorbox{blue}{\sqrt{2}}+a"#, k);
        k.selectRight();
        Expect.latex(#"\colorbox{blue}{\sqrt{2}+}a"#, k);
        k.selectRight();
        Expect.latex(#"\colorbox{blue}{\sqrt{2}+a}"#, k);
    }


    func test__Can_break_out_of_the_current_Placeholder__case_Set_a_TreeNode_as_the_new_Current()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("3"));
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"));
        k.insert(DigitNode("2"));
        k.moveRight();
        k.insert(StandardLeafNode("+"));
        k.insert(StandardLeafNode("a"));
        k.moveLeft();
        k.moveLeft();
        k.moveLeft();
        k.moveLeft();
        Expect.latex(#"3\sqrt{▦2}+a"#, k);
        k.selectRight();
        Expect.latex(#"3\sqrt{\colorbox{blue}{2}}+a"#, k);
        // Act & Assert
        k.selectRight();
        Expect.latex(#"3\colorbox{blue}{\sqrt{2}}+a"#, k);
        k.selectRight();
        Expect.latex(#"3\colorbox{blue}{\sqrt{2}+}a"#, k);
        k.selectRight();
        Expect.latex(#"3\colorbox{blue}{\sqrt{2}+a}"#, k);
    }


    func test__Does_nothing_in_an_empty_SyntaxTreeRoot()
    {
        let k = KeyboardMemory();
        Expect.latex("▦", k);
        k.selectRight();
        Expect.latex("▦", k);
    }
}
