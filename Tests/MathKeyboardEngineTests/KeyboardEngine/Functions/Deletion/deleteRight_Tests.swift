class DeleteRight_Tests : XCTestCase
{

    func test__DeleteRight_can_delete_an_empty_single_Placeholder_BranchingNode_from_its_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        Expect.latex(#"\sqrt{▦}"#, k)
        k.moveRight()
        k.insert(DigitNode("1"))
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"\sqrt{▦}1"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex("▦1", k)
        k.deleteRight()
        Expect.latex("▦", k)
    }


    func test__DeleteRight_can_delete_an_empty_multi_Placeholder_BranchingNode_from_any_Placeholder__case__first()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        Expect.latex(#"\frac{▦}{⬚}"#, k)
        k.moveRight()
        k.moveRight()
        k.insert(DigitNode("1"))
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"\frac{▦}{⬚}1"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex("▦1", k)
        k.deleteRight()
        Expect.latex("▦", k)
    }


    func test__DeleteRight_can_delete_an_empty_multi_Placeholder_BranchingNode_from_any_Placeholder__case__last()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        Expect.latex(#"\frac{▦}{⬚}"#, k)
        k.moveRight()
        k.moveRight()
        k.insert(DigitNode("1"))
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"\frac{⬚}{▦}1"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex("▦1", k)
        k.deleteRight()
        Expect.latex("▦", k)
    }


    func test__DeleteRight_does_nothing_if_an_empty_SyntaxTreeRoot_is_Current()
    {
        // Arrange
        let k = KeyboardMemory()
        // Act
        k.deleteRight()
        // Assert
        Expect.latex("▦", k)
    }


    func test__DeleteRight_does_nothing_if_there_are_only_TreeNodes_on_the_left_instead_of_the_right()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        Expect.latex("1▦", k)
        // Act
        k.deleteRight()
        // Assert
        Expect.latex("1▦", k)
    }


    func test__DeleteRight_deletes_LeafNodes_and_empty_BranchingNodes_that_are_on_the_right_of_the_cursor__Current_is_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        k.moveRight()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        Expect.latex(#"12\sqrt{⬚}\frac{▦}{⬚}"#, k)
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"▦12\sqrt{⬚}\frac{⬚}{⬚}"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex(#"▦2\sqrt{⬚}\frac{⬚}{⬚}"#, k)
        k.deleteRight()
        Expect.latex(#"▦\sqrt{⬚}\frac{⬚}{⬚}"#, k)
        k.deleteRight()
        Expect.latex(#"▦\frac{⬚}{⬚}"#, k)
        k.deleteRight()
        Expect.latex(#"▦"#, k)
    }


    func test__DeleteRight_deletes_LeafNodes_and_empty_BranchingNodes_that_are_on_the_right_of_the_cursor__Current_is_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("1"))
        k.insert(DigitNode("2"))
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        k.moveRight()
        k.insert(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        Expect.latex(#"12\sqrt{⬚}\frac{▦}{⬚}"#, k)
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"1▦2\sqrt{⬚}\frac{⬚}{⬚}"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex(#"1▦\sqrt{⬚}\frac{⬚}{⬚}"#, k)
        k.deleteRight()
        Expect.latex(#"1▦\frac{⬚}{⬚}"#, k)
        k.deleteRight()
        Expect.latex("1▦", k)
    }


    func test__DeleteRight_deletes_non_empty_single_Placeholder_BranchingNodes_in_parts__Current_is_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        k.insert(DigitNode("1"))
        k.insert(StandardLeafNode("-"))
        k.insert(StandardLeafNode("x"))
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"▦\sqrt{1-x}"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex(#"▦1-x"#, k)
        k.deleteRight()
        Expect.latex(#"▦-x"#, k)
        k.deleteRight()
        Expect.latex(#"▦x"#, k)
        k.deleteRight()
        Expect.latex("▦", k)
    }


    func test__DeleteRight_deletes_non_empty_single_Placeholder_BranchingNodes_in_parts__Current_is_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("7"))
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        k.insert(DigitNode("1"))
        k.insert(StandardLeafNode("-"))
        k.insert(StandardLeafNode("x"))
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"7▦\sqrt{1-x}"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex("7▦1-x", k)
        k.deleteRight()
        Expect.latex("7▦-x", k)
        k.deleteRight()
        Expect.latex("7▦x", k)
        k.deleteRight()
        Expect.latex("7▦", k)
    }


    func test__DeleteRight_steps_into_complex_BranchingNodes__Current_is_TreeNode()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("7"))
        k.insert(RoundBracketsNode("(", ")"))
        k.insert(DigitNode("1"))
        k.insert(StandardLeafNode("-"))
        k.insert(StandardLeafNode("x"))
        k.moveRight()
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"))
        k.insert(DigitNode("2"))
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex("7▦(1-x)^{2}", k)
        // Act & assert
        k.deleteRight()
        Expect.latex("7▦1-x^{2}", k)
        k.deleteRight()
        Expect.latex("7▦-x^{2}", k)
        k.deleteRight()
        Expect.latex("7▦x^{2}", k)
        k.deleteRight()
        Expect.latex("7▦^{2}", k)
        k.deleteRight()
        Expect.latex("7▦2", k)
        k.deleteRight()
        Expect.latex("7▦", k)
    }


    func test__DeleteRight_steps_into_complex_BranchingNodes__Current_is_Placeholder()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(RoundBracketsNode("(", ")"))
        k.insert(DigitNode("1"))
        k.insert(StandardLeafNode("-"))
        k.insert(StandardLeafNode("x"))
        k.moveRight()
        k.insertWithEncapsulateCurrent(AscendingBranchingNode("", "^{", "}"))
        k.insert(DigitNode("2"))
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex("▦(1-x)^{2}", k)
        // Act & assert
        k.deleteRight()
        Expect.latex("▦1-x^{2}", k)
        k.deleteRight()
        Expect.latex("▦-x^{2}", k)
        k.deleteRight()
        Expect.latex("▦x^{2}", k)
        k.deleteRight()
        Expect.latex("▦^{2}", k)
        k.deleteRight()
        Expect.latex("▦2", k)
        k.deleteRight()
        Expect.latex("▦", k)
    }


    func test__DeleteRight_can_delete_a_MatrixNode_with_content_gaps()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2))
        k.moveRight()
        k.insert(DigitNode("1"))
        k.moveDown()
        k.insert(StandardBranchingNode(#"\sqrt{"#, "}"))
        Expect.latex(#"\begin{pmatrix}⬚ & 1 \\ ⬚ & \sqrt{▦}\end{pmatrix}"#, k)
        k.moveUp()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"▦\begin{pmatrix}⬚ & 1 \\ ⬚ & \sqrt{⬚}\end{pmatrix}"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex(#"\begin{pmatrix}⬚ & ▦ \\ ⬚ & \sqrt{⬚}\end{pmatrix}"#, k)
        k.deleteRight()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ⬚ & ▦\end{pmatrix}"#, k)
        k.deleteRight()
        Expect.latex("▦", k)
    }


    func test__DeleteRight_can_delete_a_MatrixNode_full_content()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2))
        k.insert(DigitNode("1"))
        k.moveRight()
        k.insert(DigitNode("2"))
        k.moveRight()
        k.insert(DigitNode("3"))
        k.moveRight()
        k.insert(DigitNode("4"))
        Expect.latex(#"\begin{pmatrix}1 & 2 \\ 3 & 4▦\end{pmatrix}"#, k)
        k.moveUp()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex(#"▦\begin{pmatrix}1 & 2 \\ 3 & 4\end{pmatrix}"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex(#"\begin{pmatrix}▦ & 2 \\ 3 & 4\end{pmatrix}"#, k)
        k.deleteRight()
        Expect.latex(#"\begin{pmatrix}⬚ & ▦ \\ 3 & 4\end{pmatrix}"#, k)
        k.deleteRight()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ▦ & 4\end{pmatrix}"#, k)
        k.deleteRight()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ⬚ & ▦\end{pmatrix}"#, k)
        k.deleteRight()
        Expect.latex("▦", k)
    }


    func test__DeleteRight_does_not_delete_a_MatrixNode_from_an_empty_Placeholder_if_a_previous_Placeholder_is_not_empty()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2))
        k.insert(DigitNode("1"))
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1 & ▦ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        // Act & assert
        k.deleteRight()
        Expect.latex(#"\begin{pmatrix}1 & ▦ \\ ⬚ & ⬚\end{pmatrix}"#, k)
    }


    func test__DeleteRight_lets_the_cursor_pull_exponents_and_subscripts_towards_itself()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(AscendingBranchingNode("", "^{", "}"))
        k.moveRight()
        k.insert(DigitNode("2"))
        k.moveLeft()
        k.moveLeft()
        k.moveLeft()
        Expect.latex("▦⬚^{2}", k)
        // Act & assert
        k.deleteRight()
        Expect.latex("▦2", k)
        k.deleteRight()
        Expect.latex("▦", k)
    }
}
