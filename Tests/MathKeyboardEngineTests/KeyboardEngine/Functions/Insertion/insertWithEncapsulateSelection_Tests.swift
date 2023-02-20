class InsertWithEncapsulateSelection_Tests : XCTestCase
{

    func test__When_a_single_TreeNode_is_selected_and_the_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        Expect.latex("12▦", k);
        k.selectLeft();
        Expect.latex(#"1\colorbox{blue}{2}"#, k);
        // Act
        k.insertWithEncapsulateSelection(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"1\frac{2}{▦}"#, k);
    }


    func test__When_a_single_TreeNode_is_selected_and_the_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        Expect.latex("1▦", k);
        k.selectLeft();
        Expect.latex(#"\colorbox{blue}{1}"#, k);
        // Act
        k.insertWithEncapsulateSelection(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"\frac{1}{▦}"#, k);
    }


    func test__When_multiple_TreeNodes_are_selected_and_the_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.insert(DigitNode("3"));
        Expect.latex("123▦", k);
        k.selectLeft();
        k.selectLeft();
        Expect.latex(#"1\colorbox{blue}{23}"#, k);
        // Act
        k.insertWithEncapsulateSelection(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"1\frac{23}{▦}"#, k);
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
        k.insertWithEncapsulateSelection(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"\frac{12}{▦}"#, k);
    }



    func test__Does_a_regular_Insert_when_InSelectionMode_but_nothing_is_selected()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.enterSelectionMode();
        Expect.latex("12▦", k);
        // Act
        k.insertWithEncapsulateSelection(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"12\frac{▦}{⬚}"#, k);
    }
}
