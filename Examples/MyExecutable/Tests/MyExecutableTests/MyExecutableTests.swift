import XCTest
@testable import MyExecutable

final class MyExecutableTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(MyExecutable().finalText, #"Quadratic formula: x=\frac{-b\pm\sqrt{b^{2}-4ac}}{2a}"#)
    }
}
