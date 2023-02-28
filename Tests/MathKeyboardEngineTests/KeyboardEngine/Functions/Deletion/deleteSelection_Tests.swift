class DeleteSelection_Tests : XCTestCase
{

    func test__Can_delete_a_single_TreeNode__case_The_exclusive_left_border_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        Expect.latex("12▦", k)
        k.selectLeft()
        Expect.latex(#"1\colorbox{blue}{2}"#, k)
        // Act
        k.deleteSelection()
        // Assert
        Expect.latex("1▦", k)
    }


    func test__Can_delete_a_single_TreeNode__case_The_exclusive_left_border_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        Expect.latex("1▦", k)
        k.selectLeft()
        Expect.latex(#"\colorbox{blue}{1}"#, k)
        // Act
        k.deleteSelection()
        // Assert
        Expect.latex("▦", k)
    }


    func test__Can_delete_multiple_TreeNodes__case_The_exclusive_left_border_is_a_TreeNode__via_SelectLeft()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.insert(DigitNode("3"))
        Expect.latex("123▦", k)
        k.selectLeft()
        k.selectLeft()
        Expect.latex(#"1\colorbox{blue}{23}"#, k)
        // Act
        k.deleteSelection()
        // Assert
        Expect.latex("1▦", k)
    }


    func test__Can_delete_multiple_TreeNodes__case_The_exclusive_left_border_is_a_TreeNode__via_SelectRight()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.insert(DigitNode("3"))
        k.moveLeft()
        k.moveLeft()
        Expect.latex("1▦23", k)
        k.selectRight()
        k.selectRight()
        Expect.latex(#"1\colorbox{blue}{23}"#, k)
        // Act
        k.deleteSelection()
        // Assert
        Expect.latex("1▦", k)
    }


    func test__Can_delete_multiple_TreeNodes__case_The_exclusive_left_border_is_a_Placeholder__via_SelectLeft()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        Expect.latex("12▦", k)
        k.selectLeft()
        k.selectLeft()
        Expect.latex(#"\colorbox{blue}{12}"#, k)
        // Act
        k.deleteSelection()
        // Assert
        Expect.latex("▦", k)
    }


    func test__Can_delete_multiple_TreeNodes__case_The_exclusive_left_border_is_a_Placeholder__via_SelectRight()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.moveLeft()
        k.moveLeft()
        Expect.latex("▦12", k)
        k.selectRight()
        k.selectRight()
        Expect.latex(#"\colorbox{blue}{12}"#, k)
        // Act
        k.deleteSelection()
        // Assert
        Expect.latex("▦", k)
    }
}
