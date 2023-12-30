class GetBracketPairContent_Tests : XCTestCase {
    func test__Test() throws {
      let testCases = [
        (#"\frac{"#, "}", #"\frac{1}{2}"#, "1", "{2}"),
        (#"\frac{"#, "}", #"\frac{123}{456}"#, "123", "{456}"),
        (#"\frac{"#, "}", #"\frac{\frac{1}{1-x}}{x}"#, #"\frac{1}{1-x}"#, "{x}"),
        (#"\frac{"#, "}", #"\frac{TEST\right}and\}FORFUN}{x}"#, #"TEST\right}and\}FORFUN"#, "{x}"),
        (#"\frac{"#, "}", #"\frac{1}{2}3"#, "1", "{2}3")
        ];

      for (opening, closingBracket, sWithOpening, expectedContent, expectedRest) in testCases {
      // Act
      let result = try sWithOpening.getBracketPairContent(opening, closingBracket)
      // Assert
      XCTAssertEqual(expectedContent, result.content)
      XCTAssertEqual(expectedRest, result.rest)
    }
  }
}
