@testable import MathKeyboardEngine

class String_Tests : XCTestCase {
    func test__index_match() {
        XCTAssertEqual("b".startIndex, "b".index(of: "b"))
    }

    func test__byteIndex_match() {
        XCTAssertEqual(0, "b".byteIndex(of: "b"))
    }

    func test__index_is_nil_if_no_substring() {
        for input in ["", " ", "a"] {
            XCTAssertNil(input.index(of: "b"))
        }
    }

    func test__byteIndex_is_nil_if_no_substring() {
        for input in ["", " ", "a"] {
            XCTAssertNil(input.byteIndex(of: "b"))
        }
    }
}
