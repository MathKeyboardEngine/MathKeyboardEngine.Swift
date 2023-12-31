public class Expect {
    public static func latex(_ latex : String, _ k : KeyboardMemory) -> Void {
        let config = LatexConfiguration()
        config.activePlaceholderShape = "▦"
        config.passivePlaceholderShape = "⬚"
        config.selectionHightlightStart = #"\colorbox{blue}{"#
        config.selectionHightlightEnd = "}"
        XCTAssertEqual(latex, k.getEditModeLatex(config))
    }

    public static func viewModeLatex(_ latex : String, _ k : KeyboardMemory) -> Void {
        let config = LatexConfiguration()
        config.activePlaceholderShape = "▦"
        config.passivePlaceholderShape = "⬚"
        config.selectionHightlightStart = #"\colorbox{blue}{"#
        config.selectionHightlightEnd = "}"
        XCTAssertEqual(latex, k.getViewModeLatex(config))
    }

        public static func viewModeLatex(_ latex : String, _ x : SyntaxTreeComponent) -> Void {
        let config = LatexConfiguration()
        config.activePlaceholderShape = "▦"
        config.passivePlaceholderShape = "⬚"
        config.selectionHightlightStart = #"\colorbox{blue}{"#
        config.selectionHightlightEnd = "}"
        XCTAssertEqual(latex, x.getViewModeLatex(config))
    }
}
