class StandardBranchingNode_Tests : XCTestCase
{

    func test__Sqrt_3_right_left_left_left_right()
    {
        let k = KeyboardMemory()
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        Expect.latex(#"\sqrt{▦}"#, k)
        k.insert(DigitNode("3"))
        k.moveRight()
        Expect.latex(#"\sqrt{3}▦"#, k)
        k.moveLeft()
        Expect.latex(#"\sqrt{3▦}"#, k)
        k.moveLeft()
        Expect.latex(#"\sqrt{▦3}"#, k)
        k.moveLeft()
        Expect.latex(#"▦\sqrt{3}"#, k)
        k.moveRight()
        Expect.latex(#"\sqrt{▦3}"#, k)
    }


    func test__Sqrt_right_left_left_left_right()
    {
        let k = KeyboardMemory()
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        Expect.latex(#"\sqrt{▦}"#, k)
        k.moveRight()
        Expect.latex(#"\sqrt{⬚}▦"#, k)
        k.moveLeft()
        Expect.latex(#"\sqrt{▦}"#, k)
        k.moveLeft()
        Expect.latex(#"▦\sqrt{⬚}"#, k)
        k.moveRight()
        Expect.latex(#"\sqrt{▦}"#, k)
    }


    func test__Sqrt_del()
    {
        let k = KeyboardMemory()
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        Expect.latex(#"\sqrt{▦}"#, k)
        k.deleteLeft()
        Expect.latex("▦", k)
    }
}
