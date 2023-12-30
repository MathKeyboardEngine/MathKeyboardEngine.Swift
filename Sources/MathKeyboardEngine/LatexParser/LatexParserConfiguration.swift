open class LatexParserConfiguration {
  public init() { }
  public var additionalDigits : Array<String>? = nil
  public var decimalSeparatorMatchers : Array<String> = [".", "{,}"]
  public var preferredDecimalSeparator : (() -> String)? = nil
  public var preferRoundBracketsNode : Bool = true
}
