public class DeleteLeft_Tests : XCTestCase
{

    func test__DeleteLeft_can_also_be_used_to_delete_empty_Placeholders_in_some_cases_UX__case_x()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        k.insert(StandardLeafNode("x"));
        k.insert(StandardLeafNode("+")); // oops, typo!
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"));
        k.insert(DigitNode("3"));
        k.moveDown();
        k.deleteLeft(); // trying to fix typo
        Expect.latex("2x▦^{3}", k);
        k.moveUp();
        Expect.latex("2x⬚^{3▦}", k); // Huh? Let's delete that empty placeholder!
        k.moveDown();
        Expect.latex("2x▦^{3}", k);
        // Act
        k.deleteLeft();
        k.moveUp();
        // Assert
        Expect.latex("2x^{3▦}", k);
    }


    func test__DeleteLeft_can_also_be_used_to_delete_empty_Placeholders_in_some_cases_UX__case_1plus2point5()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(StandardLeafNode("+"));
        k.insert(DigitNode("2"));
        k.insert(DecimalSeparatorNode());
        k.insert(DigitNode("5"));
        k.insert(StandardLeafNode("+")); // oops, typo!
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"));
        Expect.latex("1+2.5+^{▦}", k);
        k.insert(DigitNode("3"));
        Expect.latex("1+2.5+^{3▦}", k);
        k.moveDown();
        k.deleteLeft(); // trying to fix typo
        Expect.latex("1+2.5▦^{3}", k);
        k.moveUp();
        Expect.latex("1+2.5⬚^{3▦}", k); // Huh? Let's delete that empty placeholder!
        k.moveDown();
        Expect.latex("1+2.5▦^{3}", k);
        // Act
        k.deleteLeft();
        Expect.latex("1+2.5▦^{3}", k);
        k.moveUp();
        // Assert
        Expect.latex("1+2.5^{3▦}", k);
    }


    func test__DeleteLeft_can_also_be_used_to_delete_empty_Placeholders_in_some_cases_UX__case_2point5()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        k.insert(DecimalSeparatorNode());
        k.insert(DigitNode("5"));
        k.insert(StandardLeafNode("+")); // oops, typo!
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"));
        k.insert(DigitNode("3"));
        k.moveDown();
        k.deleteLeft(); // trying to fix typo
        Expect.latex("2.5▦^{3}", k);
        k.moveUp();
        Expect.latex("2.5⬚^{3▦}", k); // Huh? Let's delete that empty placeholder!
        k.moveDown();
        Expect.latex("2.5▦^{3}", k);
        // Act
        k.deleteLeft();
        k.moveUp();
        // Assert
        Expect.latex("2.5^{3▦}", k);
    }


    func test__DeleteLeft_does_nothing_sometimes()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2));
        k.moveDown();
        k.insert(DigitNode("3"));
        k.moveUp();
        k.moveRight();
        Expect.latex(#"\begin{pmatrix}⬚ & ▦ \\ 3 & ⬚\end{pmatrix}"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"\begin{pmatrix}⬚ & ▦ \\ 3 & ⬚\end{pmatrix}"#, k);
    }


    func test__DeleteLeft_deletes_the_last_TreeNode_from_the_previous_Placeholders()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2));
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.moveRight();
        Expect.latex(#"\begin{pmatrix}12 & ▦ \\ ⬚ & ⬚\end{pmatrix}"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"\begin{pmatrix}1▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k);
    }


    func test__DeleteLeft_can_revert_InsertWithEncapsulateCurrent_sometimes__execution_path_with_multiple_digits_treated_as_a_single_thing()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        let powerNode = AscendingBranchingNode("", "^{", "}");
        k.insertWithEncapsulateCurrent(powerNode);
        let d3 = DigitNode("3");
        k.insert(d3);
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"));
        Expect.latex("2^{3^{▦}}", k);
        // Act & Assert
        k.deleteLeft();
        Expect.latex("2^{3▦}", k);
        XCTAssert(d3.parentPlaceholder === powerNode.placeholders[1]);
        k.deleteLeft();
        Expect.latex("2^{▦}", k);
    }



    func test__DeleteLeft_can_delete_from_the_first_Placeholder_of_a_BranchingNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        Expect.latex(#"\frac{12▦}{⬚}"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"\frac{1▦}{⬚}"#, k);
    }


    func test__DeleteLeft_can_revert__raise_selected_to_the_power_of_an_empty_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        Expect.latex("12▦", k);
        k.selectLeft();
        k.selectLeft();
        Expect.latex(#"\colorbox{blue}{12}"#, k);
        k.insertWithEncapsulateSelectionAndPrevious(AscendingBranchingNode("", "^{", "}"));
        Expect.latex("⬚^{12▦}", k);
        k.moveDown();
        Expect.latex("▦^{12}", k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex("12▦", k);
    }


    func test__DeleteLeft_from_the_right_of_a_single_Placeholder_BranchingNode__Placeholder_contains_a_TreeNodes()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(RoundBracketsNode("(", ")"));
        k.insert(DigitNode("1"));
        k.insert(StandardLeafNode("+"));
        k.insert(StandardLeafNode("x"));
        k.moveRight();
        Expect.latex("(1+x)▦", k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex("1+x▦", k);

    }


    func test__DeleteLeft_from_the_right_of_a_BranchingNode__last_Placeholder_contains_a_LeafNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        k.insert(StandardLeafNode("x"));
        k.moveRight();
        Expect.latex(#"\frac{1}{x}▦"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"\frac{1}{▦}"#, k);
    }


    func test__DeleteLeft_from_the_right_of_a_BranchingNode__last_Placeholder_contains_nested_BranchingNodes()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        k.insert(DigitNode("1"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        k.insert(DigitNode("1"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        k.insert(StandardLeafNode("x"));
        k.moveRight();
        k.moveRight();
        k.moveRight();
        Expect.latex(#"\frac{1}{\frac{1}{\frac{1}{x}}}▦"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"\frac{1}{\frac{1}{\frac{1}{▦}}}"#, k);
    }


    func test__DeleteLeft_from_the_right_of_a_BranchingNode__last_Placeholder_is_empty_and_first_Placeholder_contains_1_LeafNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        k.moveRight();
        k.moveRight();
        Expect.latex(#"\frac{1}{⬚}▦"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex("1▦", k);
    }


    func test__DeleteLeft_deletes_a_subscript_from_its_empty_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode("", "_{", "}"));
        Expect.latex("12_{▦}", k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex("12▦", k);
    }


    func test__DeleteLeft_deletes_a_subscript_from_the_right()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode("", "_{", "}"));
        k.moveRight();
        k.moveRight();
        Expect.latex("12_{⬚}▦", k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex("12▦", k);
    }


    func test__DeleteLeft_deletes_a_subscript_from_the_right__case_with_a_BranchingNode_on_the_right()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.insertWithEncapsulateCurrent(DescendingBranchingNode("", "_{", "}"));
        Expect.latex(#"12_{▦}"#, k);
        k.moveRight();
        Expect.latex(#"12_{⬚}▦"#, k);
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"));
        Expect.latex(#"12_{⬚}\sqrt{▦}"#, k);
        k.moveLeft();
        Expect.latex(#"12_{⬚}▦\sqrt{⬚}"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"12▦\sqrt{⬚}"#, k);
    }


    func test__DeleteLeft_deletes_a_single_column_matrix_or_any_BranchingNode_from_the_right_if_the_only_non_empty_Placeholder_is_at_index_0()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(MatrixNode(matrixType: "pmatrix", width: 1, height: 3));
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.moveDown();
        k.moveRight();
        k.moveRight();
        Expect.latex(#"\begin{pmatrix}12 \\ ⬚ \\ ⬚\end{pmatrix}▦"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex("12▦", k);
    }


    func test__DeleteLeft_deletes_a_fraction_from_its_second_Placeholder__case_with_a_BranchingNode_on_the_right()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"));
        k.insert(StandardLeafNode("a"));
        k.insert(StandardLeafNode("b"));
        k.moveDown();
        k.moveRight();
        Expect.latex(#"\frac{ab}{⬚}▦"#, k);
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"));
        Expect.latex(#"\frac{ab}{⬚}\sqrt{▦}"#, k);
        k.moveLeft();
        Expect.latex(#"\frac{ab}{⬚}▦\sqrt{⬚}"#, k);
        k.moveLeft();
        Expect.latex(#"\frac{ab}{▦}\sqrt{⬚}"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"ab▦\sqrt{⬚}"#, k);
    }


    func test__DeleteLeft_deletes_the_last_TreeNode_of_the_last_Placeholder_with_content()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2));
        k.insert(DigitNode("1"));
        k.insert(DigitNode("2"));
        k.moveDown();
        k.insert(DigitNode("3"));
        k.insert(DigitNode("4"));
        k.moveRight();
        k.moveRight();
        Expect.latex(#"\begin{pmatrix}12 & ⬚ \\ 34 & ⬚\end{pmatrix}▦"#, k);
        // Act & Assert
        k.deleteLeft();
        Expect.latex(#"\begin{pmatrix}12 & ⬚ \\ 3▦ & ⬚\end{pmatrix}"#, k);
        k.deleteLeft();
        Expect.latex(#"\begin{pmatrix}12 & ⬚ \\ ▦ & ⬚\end{pmatrix}"#, k);
        k.deleteLeft();
        Expect.latex(#"\begin{pmatrix}1▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k);
    }


    func test__DeleteLeft_does_nothing_from_the_first_Placeholder_if_multiple_sibling_Placeholders_are_filled()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2));
        k.moveRight();
        k.insert(DigitNode("2"));
        k.moveDown();
        k.insert(DigitNode("4"));
        k.moveLeft();
        k.moveLeft();
        k.moveUp();
        Expect.latex(#"\begin{pmatrix}▦ & 2 \\ ⬚ & 4\end{pmatrix}"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"\begin{pmatrix}▦ & 2 \\ ⬚ & 4\end{pmatrix}"#, k);
    }


    func test__DeleteLeft_deletes_a_BranchingNode_from_one_of_its_Placeholders__sets_Current_at_the_right_of_the_previous_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory();
        k.insert(DigitNode("2"));
        k.insert(StandardLeafNode(#"\times"#));
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2));
        Expect.latex(#"2\times\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k);
        // Act
        k.deleteLeft();
        // Assert
        Expect.latex(#"2\times▦"#, k);
    }
}
