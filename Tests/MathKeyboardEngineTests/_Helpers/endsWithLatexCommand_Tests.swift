@testable import MathKeyboardEngine

class EndsWithLatexCommand_Tests :XCTestCase {
    func test__True() {
        for s: String in [#"\pi"#, #"2\pi"#, #"2\times\pi"#, #"\sin"#] {
            XCTAssert(endsWithLatexCommand(s))
        }
    }

    func test__False() {
        for s: String in [#"\pi^2"#, #"\sin6"#, #"\sin a"#, "", #"\|"#, #"\\"#] {
            XCTAssertFalse(endsWithLatexCommand(s))
        }
    }
}
