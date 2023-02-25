@testable import MathKeyboardEngine

extension XCTestCase {
    func expectFatalError(_ expectedMessage: String, _ testcase: @escaping () -> Void) {
        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String = ""

        MathKeyboardEngineError.triggerFatalError = { (message, _, _) in
            assertionMessage = message()
            DispatchQueue.main.async {
                expectation.fulfill()
            }
            Thread.exit()
            Swift.fatalError("will never be executed since thread exits")
        }

        Thread(block: testcase).start()

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(expectedMessage, assertionMessage)
            MathKeyboardEngineError.triggerFatalError = Swift.fatalError
        }
    }
}