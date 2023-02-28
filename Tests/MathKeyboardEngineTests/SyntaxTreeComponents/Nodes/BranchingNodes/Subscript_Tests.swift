class Subscript_Tests : XCTestCase
{

    func test__Subscript_a_MoveRight_4()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode("", "_{", "}"))
        k.insert(StandardLeafNode("a"))
        k.moveRight()
        k.insert(DigitNode("4"))
        Expect.latex("a_{4▦}", k)
    }


    func test__Subscript_a_MoveDown_4()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode("", "_{", "}"))
        k.insert(StandardLeafNode("a"))
        k.moveDown()
        k.insert(DigitNode("4"))
        Expect.latex("a_{4▦}", k)
    }


    func test__InsertWithEncapsulateCurrent()
    {
        let k = KeyboardMemory()
        k.insert(StandardLeafNode("a"))
        k.insertWithEncapsulateCurrent(DescendingBranchingNode("", "_{", "}"))
        Expect.latex("a_{▦}", k)
    }


    func test__Subscript_a_MoveDown_4_MoveUp()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode("", "_{", "}"))
        k.insert(StandardLeafNode("a"))
        k.moveDown()
        k.insert(DigitNode("4"))
        Expect.latex("a_{4▦}", k)
        k.moveUp()
        Expect.latex("a▦_{4}", k)
    }


    func test__Can_be_left_empty__moving_out_and_back_in()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode("", "_{", "}"))
        Expect.latex("▦_{⬚}", k)
        // Act & Assert
        k.moveLeft()
        Expect.latex("▦⬚_{⬚}", k)
        k.moveRight()
        Expect.latex("▦_{⬚}", k)
    }


    func test__Impossible_updown_requests_in_empty_subscriptNode_should_not_throw()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode("", "_{", "}"))
        Expect.latex("▦_{⬚}", k)
        // Act & Assert 1
        k.moveUp()
        Expect.latex("▦_{⬚}", k)
        // Arrange 2
        k.moveDown()
        Expect.latex("⬚_{▦}", k)
        // Act & Assert 2
        k.moveDown()
        Expect.latex("⬚_{▦}", k)
    }


    func test__Impossible_updown_requests_in_filled_subscriptNode_should_not_throw()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode("", "_{", "}"))
        k.insert(StandardLeafNode("a"))
        Expect.latex("a▦_{⬚}", k)
        // Act & Assert 1
        k.moveUp()
        Expect.latex("a▦_{⬚}", k)
        // Arrange 2
        k.moveDown()
        k.insert(DigitNode("4"))
        Expect.latex("a_{4▦}", k)
        // Act & Assert 2
        k.moveDown()
        Expect.latex("a_{4▦}", k)
    }
}
