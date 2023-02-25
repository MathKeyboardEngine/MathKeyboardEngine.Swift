@testable import MathKeyboardEngine

class PopSelection_Tests : XCTestCase
{
    func test__Error_if_not_InSelectionMode() {
        for shouldBeFatal in [true, false] {
            MathKeyboardEngineError.shouldBeFatal = shouldBeFatal
            let k = KeyboardMemory()
            let act = {  _ = k.popSelection() }
            if shouldBeFatal {
                expectFatalError("Enter selection mode before calling this method.", act)
            } else {
                act()
            }
        }
    }


    func test__Returns_an_empty_List_when_InSelectionMode_but_nothing_is_selected() {
        let k = KeyboardMemory()
        k.enterSelectionMode()
        let nodesArray = k.popSelection()
        XCTAssert(nodesArray.isEmpty)
    }
}
