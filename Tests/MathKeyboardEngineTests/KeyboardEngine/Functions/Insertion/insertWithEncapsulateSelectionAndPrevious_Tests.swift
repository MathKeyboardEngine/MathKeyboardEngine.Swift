class InsertWithEncapsulateSelectionAndPrevious_Tests
{

    func test__When_a_single_TreeNode_is_selected_and_the_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        k.insert(DigitNode("3"));
        Expect.latex("23▦", k);
        k.selectLeft();
        Expect.latex(#"2\colorbox{blue}{3}"#, k);
        // Act
        k.insertWithEncapsulateSelectionAndPrevious(AscendingBranchingNode("", "^{", "}"));
        // Assert
        Expect.latex("2^{3▦}", k);
    }


    func test__When_a_single_TreeNode_is_selected_and_the_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        Expect.latex("2▦", k);
        k.selectLeft();
        Expect.latex(#"\colorbox{blue}{2}"#, k);
        // Act
        k.insertWithEncapsulateSelectionAndPrevious(AscendingBranchingNode("", "^{", "}"));
        // Assert
        Expect.latex("⬚^{2▦}", k);
    }


    func test__When_multiple_TreeNodes_are_selected_and_the_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        k.insert(DigitNode("1"));
        k.insert(DigitNode("0"));
        Expect.latex("210▦", k);
        k.selectLeft();
        k.selectLeft();
        Expect.latex(#"2\colorbox{blue}{10}"#, k);
        // Act
        k.insertWithEncapsulateSelectionAndPrevious(AscendingBranchingNode("", "^{", "}"));
        // Assert
        Expect.latex("2^{10▦}", k);
    }


    func test__When_multiple_TreeNodes_are_selected_and_the_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        Expect.latex("12▦", k);
        k.selectLeft();
        k.selectLeft();
        Expect.latex(#"\colorbox{blue}{12}"#, k);
        // Act
        k.insertWithEncapsulateSelectionAndPrevious(AscendingBranchingNode("", "^{", "}"));
        // Assert
        Expect.latex("⬚^{12▦}", k);
    }


    func test__Invokes_InsertWithEncapsulateCurrent_if_InSelectionMode_but_nothing_selected()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(StandardLeafNode("+"));
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.enterSelectionMode();
        Expect.latex("1+12▦", k);
        // Act
        k.insertWithEncapsulateSelectionAndPrevious(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"1+\frac{12}{▦}"#, k);
    }


    func test__Throws_on_inserting_BranchingNode_with_single_Placeholder()
    {
        let k = KeyboardMemory();
        XCTAssertThrows(message: "Expected 2 Placeholders.", {
            k.insertWithEncapsulateSelectionAndPrevious(StandardBranchingNode("[", "]"))
        });
    }
}
