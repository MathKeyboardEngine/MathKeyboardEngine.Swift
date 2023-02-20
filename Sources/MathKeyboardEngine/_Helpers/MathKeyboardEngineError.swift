public class MathKeyboardEngineError : Error {
    public var message : String
    init(_ message : String) {
        self.message = message
    }
}