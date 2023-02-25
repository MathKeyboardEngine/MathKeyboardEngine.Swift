open class LatexConfiguration {
  public var activePlaceholderShape : String = #"\blacksquare"# 
  public var activePlaceholderColor: String?
  public var passivePlaceholderShape: String = #"\square"#
  public var passivePlaceholderColor: String?
  public var selectionHightlightStart: String = #"\colorbox{#ADD8E6}{\(\displaystyle"#
  public var selectionHightlightEnd : String = #"\)}"#

  public init() { }

  open var activePlaceholderLatex : String {
    get {
      if let color = activePlaceholderColor {
        return #"{\color{\#(color)}\#(activePlaceholderShape)}"#
      } else {
        return activePlaceholderShape
      }
    }
  }

  open var passivePlaceholderLatex: String {
    get{
      if let color = passivePlaceholderColor {
        return #"{\color{\#(color)}\#(passivePlaceholderShape)}"#
      } else {
        return passivePlaceholderShape
      }
    }
  }
}
