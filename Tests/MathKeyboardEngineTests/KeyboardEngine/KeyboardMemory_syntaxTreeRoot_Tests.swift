class KeyboardMemory_SyntaxTreeRoot_Tests : XCTestCase
{

    func test__SyntaxTreeRoot_is_equal_to_Current_on_KeyboardMemory_initialization()
    {
        let k = KeyboardMemory();
        XCTAssertNotNil(k.syntaxTreeRoot);
        XCTAssert(k.current === k.syntaxTreeRoot);
    }

    func test__SyntaxTreeRoot_cannot_be_deleted()
    {
        let k = KeyboardMemory();
        k.deleteLeft();
        XCTAssertNotNil(k.syntaxTreeRoot);
    }


    func test__SyntaxTreeRoot_is_reachable_via_the_chain_of_parents()
    {
        let k = KeyboardMemory();

        let fraction1 = DescendingBranchingNode(#"\frac{"#, "}{", "}");
        k.insert(fraction1);
        XCTAssert(k.current === fraction1.placeholders[0]);

        let fraction2 = DescendingBranchingNode(#"\frac{"#, "}{", "}");
        k.insert(fraction2);
        XCTAssert(k.current === fraction2.placeholders[0]);

        let calculatedRoot = (k.current as! Placeholder).parentNode!.parentPlaceholder.parentNode!.parentPlaceholder!
        XCTAssertNil(calculatedRoot.parentNode);
        XCTAssert(k.syntaxTreeRoot === calculatedRoot);
    }


    func test__Impossible_move_requests_in_an_empty_root_Placeholder_do_not_throw()
    {
        let k = KeyboardMemory();
        Expect.latex("▦", k);
        k.moveLeft();
        Expect.latex("▦", k);
        k.moveDown();
        Expect.latex("▦", k);
        k.moveUp();
        Expect.latex("▦", k);
        k.moveRight();
        Expect.latex("▦", k);
    }


    func test__Impossible_move_requests_in_a_filled_root_Placeholder_do_not_throw()
    {
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        Expect.latex("1▦", k);
        k.moveUp();
        Expect.latex("1▦", k);
        k.moveRight();
        Expect.latex("1▦", k);
        k.moveDown();
        Expect.latex("1▦", k);
        k.moveLeft();
        Expect.latex("▦1", k);
        k.moveDown();
        Expect.latex("▦1", k);
        k.moveLeft();
        Expect.latex("▦1", k);
        k.moveUp();
        Expect.latex("▦1", k);
    }
}
