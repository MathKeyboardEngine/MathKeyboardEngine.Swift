class StandardLeafNode_Tests : XCTestCase
{

    func test__The_StandardLeafNode_allows_customizing_the_multiplication_operator_sign_even_if_it_is_already_in_the_KeyboardMemorys_syntax_tree()
    {
        // Arrange
        var myMultiplicationSignSetting = #"\times"#;
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        k.insert(StandardLeafNode({ return myMultiplicationSignSetting }));
        k.insert(StandardLeafNode("a"));
        Expect.latex(#"2\times a▦"#, k);
        // Act
        myMultiplicationSignSetting = #"\cdot"#;
        // Assert
        Expect.latex(#"2\cdot a▦"#, k);
    }
}
