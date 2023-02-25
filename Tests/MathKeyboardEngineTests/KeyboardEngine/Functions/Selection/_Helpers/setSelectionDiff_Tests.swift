@testable import MathKeyboardEngine

class SetSelectionDiff_Tests : XCTestCase
{
    func test__Does_nothing_at_nonsensical_requests() {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.selectLeft()
        Expect.latex(#"\colorbox{blue}{1}"#, k)
        let currentSelectionDiff = k.selectionDiff!
        // Act
        k.setSelectionDiff(currentSelectionDiff - 1) // Trying to go even more to the left.
        // Assert does nothing
        XCTAssertEqual(currentSelectionDiff, k.selectionDiff!)
    }
}
