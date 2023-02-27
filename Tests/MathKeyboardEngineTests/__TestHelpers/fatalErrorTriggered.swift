@testable import MathKeyboardEngine

extension XCTestCase {
    func fatalErrorTriggered(_ expectedMessage: String, _ testcase: @escaping () -> Void) -> Bool {
        var actualMessage: String = ""

        MathKeyboardEngineError.triggerFatalError = { (message, _, _) in
            actualMessage = message()
            Thread.exit()
            abort()
        }

        Thread(block: testcase).start()
        Thread.sleep(forTimeInterval: 0.1)

        MathKeyboardEngineError.triggerFatalError = Swift.fatalError
        return expectedMessage == actualMessage
    }
}

class XCTestCaseFatalErrorTriggered_Tests : XCTestCase {
    func test__no_fatalError_triggered() {
        XCTAssertFalse(fatalErrorTriggered("Let's pretend we expect failure", {}))
    }

    func test__fatalError_with_wrong_message_triggered() {
        XCTAssertFalse(fatalErrorTriggered("Expect A", { MathKeyboardEngineError.triggerFatalError("Actual B", #file, #line) }))
    }

    func test__fatalError_has_expected_message() {
        XCTAssertTrue(fatalErrorTriggered("ABC", { MathKeyboardEngineError.triggerFatalError("ABC", #file, #line) }))
    }
}