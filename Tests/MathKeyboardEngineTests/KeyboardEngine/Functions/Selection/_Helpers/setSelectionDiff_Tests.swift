@testable import MathKeyboardEngine

class SetSelectionDiff_Tests : XCTestCase
{
    func test__Throws_at_nonsensical_requests() {

        for shouldBeFatal in [true, false] {
            // Arrange
            MathKeyboardEngineError.shouldBeFatal = shouldBeFatal
            let k = KeyboardMemory()
            k.insert(DigitNode("1"))
            k.selectLeft()
            Expect.latex(#"\colorbox{blue}{1}"#, k)
            let currentSelectionDiff = k.selectionDiff!
            MathKeyboardEngineError.shouldBeFatal = shouldBeFatal

            // Act & assert
            let act = { k.setSelectionDiff(currentSelectionDiff - 1) } // Trying to go even more to the left.
            if shouldBeFatal {
                XCTAssertTrue(fatalErrorTriggered("The TreeNode at index 0 of the current Placeholder is as far as you can go left if current is a TreeNode.", act))
            } else {
                act()
                XCTAssertEqual(currentSelectionDiff, k.selectionDiff!) // did nothing

            }
        }
    }
}
