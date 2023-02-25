public class Insert_Tests : XCTestCase
{

    func test__Insert_inserts_at_index_0_of_a_TreeNodeList_if_KeyboardMemory_Current_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        let d1 = DigitNode("1")
        k.insert(d1)
        Expect.latex("1▦", k)
        k.moveLeft()
        XCTAssert(k.current === d1.parentPlaceholder)
        Expect.latex("▦1", k)
        // Act
        k.insert(DigitNode("2"))
        // Assert
        Expect.latex("2▦1", k)
    }


    func test__Insert_inserts_at_the_right_of_a_TreeNode_if_KeyboardMemory_Current_is_a_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory()
        let d1 = DigitNode("1")
        k.insert(d1)
        XCTAssert(k.current === d1)
        Expect.latex("1▦", k)
        // Act 1
        k.insert(DigitNode("2"))
        // Assert 1
        Expect.latex("12▦", k)
        // Arrange 2
        k.moveLeft()
        XCTAssert(k.current === d1)
        Expect.latex("1▦2", k)
        // Act 2
        k.insert(DigitNode("3"))
        // Assert 2
        Expect.latex("13▦2", k)
    }


    func test__Insert_sets_the_ParentPlaceholder()
    {
        // Arrange
        let k = KeyboardMemory()
        let node = DigitNode("1")
        XCTAssertNil(node.parentPlaceholder)
        // Act
        k.insert(node)
        // Assert
        XCTAssertNotNil(node.parentPlaceholder)
    }


    func test__Insert_sets_KeyboardMemory_Current()
    {
        // Arrange
        let k = KeyboardMemory()
        let originalCurrent = k.current
        // Act
        k.insert(DigitNode("1"))
        // Assert
        XCTAssert(originalCurrent !== k.current)
    }
}
