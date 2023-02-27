class TreeNode_Tests : XCTestCase {
    
    func test__getLatexPartShouldBeOverridden() {
        let k = KeyboardMemory()
        let config = LatexConfiguration()

        let act = { return DummyTreeNode().getLatexPart(k, config) }
        let expectedMessage = " NotImplemented: 'getLatexPart'. "
        for shouldBeFatal in [true, false] {
            MathKeyboardEngineError.shouldBeFatal = shouldBeFatal
            if shouldBeFatal {
                XCTAssertTrue(fatalErrorTriggered(expectedMessage, { _ = act()}))
            } else {
                XCTAssertEqual(expectedMessage, act())
            }
        }
    }
}

open class DummyTreeNode : TreeNode { }