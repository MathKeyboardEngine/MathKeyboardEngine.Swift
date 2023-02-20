class MoveDown_Tests : XCTestCase
{
    func test__MoveDown_can_move_the_cursor_down_via_an_ancestor_if_the_current_BranchginNode_does_not_support_updown_navigation()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"));
        k.insert(RoundBracketsNode("(", ")"));
        Expect.latex("2^{(▦)}", k);
        // Act
        k.moveDown();
        // Assert
        Expect.latex("2▦^{(⬚)}", k);
    }
}
