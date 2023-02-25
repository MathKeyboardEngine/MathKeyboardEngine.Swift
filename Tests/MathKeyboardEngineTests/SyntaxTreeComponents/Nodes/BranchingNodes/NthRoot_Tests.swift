class NthRoot_Tests : XCTestCase
{

    func test__Basic_test()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\sqrt["#, "]{", "}"))
        Expect.latex(#"\sqrt[▦]{⬚}"#, k)
        k.insert(DigitNode("3"))
        k.moveRight()
        Expect.latex(#"\sqrt[3]{▦}"#, k)
        k.insert(DigitNode("2"))
        k.insert(DigitNode("7"))
        Expect.latex(#"\sqrt[3]{27▦}"#, k)
    }


    func test__MoveUp_MoveDown__including_impossible_updown_requests()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\sqrt["#, "]{", "}"))
        Expect.latex(#"\sqrt[▦]{⬚}"#, k)
        // Act & Assert MoveDown
        k.moveDown()
        Expect.latex(#"\sqrt[⬚]{▦}"#, k)
        k.moveDown()
        Expect.latex(#"\sqrt[⬚]{▦}"#, k)
        // Act && Assert MoveUp
        k.moveUp()
        Expect.latex(#"\sqrt[▦]{⬚}"#, k)
        k.moveUp()
        Expect.latex(#"\sqrt[▦]{⬚}"#, k)
    }
}
