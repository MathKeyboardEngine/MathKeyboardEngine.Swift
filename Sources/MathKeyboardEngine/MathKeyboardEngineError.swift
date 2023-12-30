public class MathKeyboardEngineError : Error {
    public init(_ message : String) {
        self.message = message
    }
    public var message : String
    public static var shouldBeFatal : Bool = true
    internal static var triggerFatalError: (@autoclosure () -> String, StaticString, UInt) -> Never = Swift.fatalError
}