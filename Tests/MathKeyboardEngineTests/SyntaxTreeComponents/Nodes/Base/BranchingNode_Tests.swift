@testable import MathKeyboardEngine

public class BranchingNode_Tests : XCTestCase {
    public func test__Calling_MoveUp_or_MoveDown_does_not_throw_even_if_not_implemented() {
        let k = KeyboardMemory()
        k.insert(DummyBranchingNode())
        Expect.latex("wow >> ▦ << wow", k)
        k.moveUp()
        Expect.latex("wow >> ▦ << wow", k)
        k.moveDown()
        Expect.latex("wow >> ▦ << wow", k)
    }

    public class DummyBranchingNode : BranchingNode {
        public init() {
            super.init(ReferenceArray<Placeholder>(Placeholder()))
        }

        open override func getLatexPart(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String {
            return "wow >> \(self.placeholders[0].getLatex(k, latexConfiguration)) << wow"
        }
    }
}
