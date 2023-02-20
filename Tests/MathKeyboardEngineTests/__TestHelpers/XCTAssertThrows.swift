import XCTest


func XCTAssertThrows(message: String = "", file: StaticString = #file, line: UInt = #line, _ block: () throws -> ())
{
    do
    {
        try block()
        XCTFail("Tested block did not throw an error with message '\(message)'as expected.", file: file, line: line)
    }
    catch let error {
        let mkeError = error as? MathKeyboardEngineError
        if mkeError == nil || mkeError!.message != message {
            XCTFail("Tested block did not throw an error with message '\(message)'as expected.", file: file, line: line)
        }
     }
}