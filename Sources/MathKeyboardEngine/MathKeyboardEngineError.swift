public class MathKeyboardEngineError : Error {
    public static var shouldBeFatal : Bool = true
    internal static var triggerFatalError: (@autoclosure () -> String, StaticString, UInt) -> Never = Swift.fatalError
}