class Power_Tests : XCTestCase
{

    func test__Power_3_MoveRight_4()
    {
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        k.insert(DigitNode("3"))
        k.moveRight()
        k.insert(DigitNode("4"))
        Expect.latex("3^{4▦}", k)
    }


    func test__Power_3_MoveUp_4()
    {
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        k.insert(DigitNode("3"))
        k.moveUp()
        k.insert(DigitNode("4"))
        Expect.latex("3^{4▦}", k)
    }


    func test__Three_encapsulated_by_Power()
    {
        let k = KeyboardMemory()
        k.insert(DigitNode("3"))
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"))
        Expect.latex("3^{▦}", k)
    }


    func test__Power_3_up_down()
    {
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        k.insert(DigitNode("3"))
        k.moveUp()
        k.insert(DigitNode("4"))
        k.moveDown()
        Expect.latex("3▦^{4}", k)
    }


    func test__Poewr_can_be_left_empty__moving_out_and_back_in()
    {
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        Expect.latex("▦^{⬚}", k)
        k.moveLeft()
        Expect.latex("▦⬚^{⬚}", k)
        k.moveRight()
        Expect.latex("▦^{⬚}", k)
    }


    func test__Impossible_updown_requests_in_an_empty_power_should_not_throw()
    {
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        Expect.latex("▦^{⬚}", k)
        k.moveDown()
        Expect.latex("▦^{⬚}", k)
        k.moveUp()
        Expect.latex("⬚^{▦}", k)
        k.moveUp()
        Expect.latex("⬚^{▦}", k)
    }


    func test__Impossible_updown_requests_in_a_filled_power_should_not_throw()
    {
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        k.insert(DigitNode("3"))
        Expect.latex("3▦^{⬚}", k)
        k.moveDown()
        Expect.latex("3▦^{⬚}", k)
        k.moveUp()
        Expect.latex("3^{▦}", k)
        k.insert(DigitNode("4"))
        Expect.latex("3^{4▦}", k)
        k.moveUp()
        Expect.latex("3^{4▦}", k)
    }
}
