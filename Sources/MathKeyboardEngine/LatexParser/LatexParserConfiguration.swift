open class LatexParserConfiguration {
  public init() { }
  open var additionalDigits : Array<String>? = nil
  open var decimalSeparatorMatchers : Array<String> = [".", "{,}"]
  open var preferredDecimalSeparator : (() -> String)? = nil
  open var preferRoundBracketsNode : Bool = true
}
