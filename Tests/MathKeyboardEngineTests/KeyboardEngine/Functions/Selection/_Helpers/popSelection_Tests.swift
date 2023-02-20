@testable import MathKeyboardEngine

class PopSelection_Tests : XCTestCase
{
    func test__Does_not_throw_if_not_InSelectionMode() {
        let k = KeyboardMemory();
        _ = k.popSelection()
    }


    func test__Returns_an_empty_List_when_InSelectionMode_but_nothing_is_selected() {
        let k = KeyboardMemory();
        k.enterSelectionMode();
        let nodesArray = k.popSelection();
        XCTAssert(nodesArray.isEmpty);
    }
}
