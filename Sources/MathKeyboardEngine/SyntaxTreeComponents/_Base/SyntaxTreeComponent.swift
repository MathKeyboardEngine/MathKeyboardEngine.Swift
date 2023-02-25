public protocol SyntaxTreeComponent : AnyObject {
    func getLatex(_ k: KeyboardMemory, _ latexConfiguration: LatexConfiguration) -> String
}