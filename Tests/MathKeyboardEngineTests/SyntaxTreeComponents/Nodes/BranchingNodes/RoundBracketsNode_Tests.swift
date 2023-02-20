class RoundBracketsNode_Tests : XCTestCase
{
    func test__Default_bracket_style()
    {
        let k = KeyboardMemory();
        k.insert(RoundBracketsNode());
        Expect.latex(#"\left(▦\right)"#, k);
    }


    func test__Bracket_style_can_be_overridden()
    {
        let k = KeyboardMemory();
        k.insert(RoundBracketsNode("(", ")"));
        Expect.latex("(▦)", k);
    }
}
