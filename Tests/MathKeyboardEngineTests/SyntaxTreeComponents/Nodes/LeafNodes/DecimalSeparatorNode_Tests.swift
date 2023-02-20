class DecimalSeparatorNode_Tests : XCTestCase
{
    func test__The_DecimalSeparatorNode_allows_customizing_the_separator_even_if_it_is_already_in_the_KeyboardMemorys_syntax_tree()
    {
        // Arrange
        var myDecimalSeparatorSetting = "{,}";
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DecimalSeparatorNode( { return myDecimalSeparatorSetting }));
        k.insert(DigitNode("2"));
        Expect.latex("1{,}2▦", k);
        // Act
        myDecimalSeparatorSetting = ".";
        // Assert
        Expect.latex("1.2▦", k);
    }
}
