open class LatexConfiguration {
  public var activePlaceholderShape : String = #"\blacksquare"# 
  public var activePlaceholderColor: String?
  public var passivePlaceholderShape: String = #"\square"#
  public var passivePlaceholderColor: String?
  public var selectionHightlightStart: String = #"\colorbox{#ADD8E6}{\(\displaystyle"#
  public var selectionHightlightEnd : String = #"\)}"#

  public init() { }

  open var activePlaceholderLatex : String {
    get{
      if (activePlaceholderColor == nil) {
        return activePlaceholderShape
      } else {
        return #"{\color{\#(self.activePlaceholderColor!)}\#(self.activePlaceholderShape)}"#
      }
    }
  }

  open var passivePlaceholderLatex: String {
    get{
      if (passivePlaceholderColor == nil) {
        return passivePlaceholderShape
      } else {
        return #"{\color{\#(self.passivePlaceholderColor!)}\#(self.passivePlaceholderShape)}"#
      }
    }
  }
}
