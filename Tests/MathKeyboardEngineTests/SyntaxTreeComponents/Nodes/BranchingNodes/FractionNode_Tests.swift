class FractionNode_Tests : XCTestCase
{

    func test__Frac_left_right_right_right()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.moveLeft()
        Expect.latex(#"▦\frac{⬚}{⬚}"#, k)
        k.moveRight()
        Expect.latex(#"\frac{▦}{⬚}"#, k)
        k.moveRight()
        Expect.latex(#"\frac{⬚}{▦}"#, k)
        k.moveRight()
        Expect.latex(#"\frac{⬚}{⬚}▦"#, k)
    }


    func test__Frac_3_right_4()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.insert(DigitNode("3"))
        k.moveRight()
        k.insert(DigitNode("4"))
        Expect.latex(#"\frac{3}{4▦}"#, k)
    }


    func test__Frac_3_down_4()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.insert(DigitNode("3"))
        k.moveDown()
        k.insert(DigitNode("4"))
        Expect.latex(#"\frac{3}{4▦}"#, k)
    }


    func test__Three_encapsulated_by_the_numerator_of_a_fraction()
    {
        let k = KeyboardMemory()
        k.insert(DigitNode("3"))
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        Expect.latex(#"\frac{3}{▦}"#, k)
    }


    func test__Delete_empty_fraction_from_numerator()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        Expect.latex(#"\frac{▦}{⬚}"#, k)
        k.deleteLeft()
        Expect.latex("▦", k)
    }


    func test__Delete_empty_fraction_from_denominator()
    {
        let k = KeyboardMemory()
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.moveDown()
        Expect.latex(#"\frac{⬚}{▦}"#, k)
        k.deleteLeft()
        Expect.latex("▦", k)
    }


    func test__Delete_empty_fraction_from_right()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.moveDown()
        k.moveRight()
        Expect.latex(#"\frac{⬚}{⬚}▦"#, k)
        k.deleteLeft()
        Expect.latex("▦", k)
    }


    func test__Deleting_fraction_from_denominator_releases_nonempty_numerator()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.moveDown()
        k.insert(DigitNode("3"))
        k.moveRight()
        Expect.latex(#"\frac{12}{3}▦"#, k)
        k.deleteLeft()
        Expect.latex(#"\frac{12}{▦}"#, k)
        k.deleteLeft()
        Expect.latex("12▦", k)
    }


    func test__MoveUp_in_filled_fraction()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.moveDown()
        k.insert(DigitNode("3"))
        Expect.latex(#"\frac{12}{3▦}"#, k)
        k.moveUp()
        Expect.latex(#"\frac{12▦}{3}"#, k)
    }


    func test__Impossible_updown_requests_in_filled_fraction_should_not_throw()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.insert(DigitNode("1"))
        Expect.latex(#"\frac{1▦}{⬚}"#, k)
        k.moveUp()
        Expect.latex(#"\frac{1▦}{⬚}"#, k)

        k.moveDown()
        k.insert(DigitNode("2"))
        Expect.latex(#"\frac{1}{2▦}"#, k)
        k.moveDown()
        Expect.latex(#"\frac{1}{2▦}"#, k)
    }


    func test__Impossible_updown_requests_in_empty_fraction_should_not_throw()
    {
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.moveDown()
        Expect.latex(#"\frac{⬚}{▦}"#, k)
        k.moveDown()
        Expect.latex(#"\frac{⬚}{▦}"#, k)
        k.moveUp()
        Expect.latex(#"\frac{▦}{⬚}"#, k)
        k.moveUp()
        Expect.latex(#"\frac{▦}{⬚}"#, k)
    }
}
