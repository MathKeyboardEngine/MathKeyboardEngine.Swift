public class InsertWithEncapsulateCurrent_Tests : XCTestCase
{

    func test__Does_a_regular_insert_if_Current_is_a_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        XCTAssertTrue(k.current is Placeholder);
        // Act
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"));
        // Assert
        Expect.latex("▦^{⬚}", k);
    }


    func test__Can_encapsulate_complex_stuff_like_matrixes()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2));
        for i in 1...4 {
            k.insert(DigitNode(String(i)));
            k.moveRight();
        }
        Expect.latex(#"\begin{pmatrix}1 & 2 \\ 3 & 4\end{pmatrix}▦"#, k);

        // Act
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"\frac{\begin{pmatrix}1 & 2 \\ 3 & 4\end{pmatrix}}{▦}"#, k);
    }


    func test__Can_also_be_used_in__for_example__a_matrix()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2));
        k.insert(DigitNode("2"));
        // Act
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"));
        // Assert
        Expect.latex(#"\begin{pmatrix}2^{▦} & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k);
    }


    func test__Can_encapsulate_multiple_digits()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        // Act
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"\frac{12}{▦}"#, k);
    }


    func test__Can_encapsulate_a_decimal_number()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.insert(DecimalSeparatorNode());
        k.insert(DigitNode("3"));
        // Act
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"\frac{12.3}{▦}"#, k);
    }


    func test__Does_not_encapsulate_more_than_it_should()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(StandardLeafNode("+"));
        k.insert(DigitNode("2"));
        k.insert(DigitNode("3"));
        // Act
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        // Assert
        Expect.latex(#"1+\frac{23}{▦}"#, k);
    }


    func test__Can_encapsulate_round_brackets()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(StandardLeafNode("+"));
        k.insert(RoundBracketsNode("(", ")"));
        k.insert(DigitNode("2"));
        k.insert(StandardLeafNode("+"));
        k.insert(DigitNode("3"));
        Expect.latex("1+(2+3▦)", k);

        k.moveRight();
        Expect.latex("1+(2+3)▦", k);
        let powerNode = AscendingBranchingNode("", "^{", "}");
        // Act
        k.insertWithEncapsulateCurrent(powerNode);
        // Assert
        Expect.latex("1+(2+3)^{▦}", k);
        XCTAssertEqual("(2+3)", powerNode.placeholders[0].getLatex(k, LatexConfiguration()));
    }


    func test__With_DeleteOuterRoundBracketsIfAny__deletes_outer_round_brackets_during_encapsulation()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(StandardLeafNode("+"));
        k.insert(RoundBracketsNode("(", ")"));
        k.insert(RoundBracketsNode("(", ")"));
        k.insert(StandardLeafNode("x"));
        k.insert(StandardLeafNode("+"));
        k.insert(DigitNode("2"));
        k.moveRight();
        k.insert(RoundBracketsNode("(", ")"));
        k.insert(StandardLeafNode("x"));
        k.insert(StandardLeafNode("-"));
        k.insert(DigitNode("3"));
        k.moveRight();
        k.moveRight();
        Expect.latex("1+((x+2)(x-3))▦", k);
        // Act
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"), deleteOuterRoundBracketsIfAny: true);
        // Assert
        Expect.latex(#"1+\frac{(x+2)(x-3)}{▦}"#, k);
    }


    func test__With_DeleteOuterRoundBracketsIfAny__does_not_delete_square_brackets_during_encapsulation()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(StandardLeafNode("+"));
        k.insert(StandardBranchingNode("|", "|"));
        k.insert(StandardLeafNode("x"));
        k.insert(StandardLeafNode("+"));
        k.insert(DigitNode("3"));
        k.moveRight();
        Expect.latex("1+|x+3|▦", k);
        // Act
        let fraction = DescendingBranchingNode(#"\frac{"#, "}{", "}");
        k.insertWithEncapsulateCurrent(fraction, deleteOuterRoundBracketsIfAny: true);
        // Assert
        Expect.latex(#"1+\frac{|x+3|}{▦}"#, k);
    }


    func test__With_DeleteOuterRoundBracketsIfAny__encapsulation_by_single_Placeholder_BranchingNode_sets_the_cursor_at_the_right_of_the_new_BranchingNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(RoundBracketsNode("(", ")"));
        k.insert(StandardLeafNode("A"));
        k.insert(StandardLeafNode("B"));
        k.moveRight();
        Expect.latex("(AB)▦", k);
        // Act
        k.insertWithEncapsulateCurrent(StandardBranchingNode(#"\overrightarrow{"#, "}"), deleteOuterRoundBracketsIfAny: true);
        // Assert
        Expect.latex(#"\overrightarrow{AB}▦"#, k);
    }
}
