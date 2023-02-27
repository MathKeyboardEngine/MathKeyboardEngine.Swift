public class MatrixNode_Tests : XCTestCase
{

    func test__PMatrix_width2_height3()
    {
        let k = KeyboardMemory()
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 3))
        Expect.latex(#"\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        k.insert(DigitNode("1"))
        k.moveRight()
        k.insert(DigitNode("2"))
        k.moveDown()
        k.insert(DigitNode("4"))
        k.moveDown()
        k.insert(DigitNode("6"))
        Expect.latex(#"\begin{pmatrix}1 & 2 \\ ⬚ & 4 \\ ⬚ & 6▦\end{pmatrix}"#, k)
    }


    func test__Move_through_all_the_cells_of_a_MatrixNode_with_MoveLeft_and_MoveRight()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2))
        k.insert(DigitNode("1"))
        k.moveRight()
        k.moveRight()
        k.insert(DigitNode("3"))
        k.moveRight()
        k.insert(DigitNode("4"))
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ 3 & 4▦\end{pmatrix}"#, k)
        // Act & Assert MoveLeft
        k.moveLeft()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ 3 & ▦4\end{pmatrix}"#, k)
        k.moveLeft()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ 3▦ & 4\end{pmatrix}"#, k)
        k.moveLeft()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ ▦3 & 4\end{pmatrix}"#, k)
        k.moveLeft()
        Expect.latex(#"\begin{pmatrix}1 & ▦ \\ 3 & 4\end{pmatrix}"#, k)
        k.moveLeft()
        Expect.latex(#"\begin{pmatrix}1▦ & ⬚ \\ 3 & 4\end{pmatrix}"#, k)
        k.moveLeft()
        Expect.latex(#"\begin{pmatrix}▦1 & ⬚ \\ 3 & 4\end{pmatrix}"#, k)
        k.moveLeft()
        Expect.latex(#"▦\begin{pmatrix}1 & ⬚ \\ 3 & 4\end{pmatrix}"#, k)
        // Act & Assert MoveRight
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}▦1 & ⬚ \\ 3 & 4\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1▦ & ⬚ \\ 3 & 4\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1 & ▦ \\ 3 & 4\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ ▦3 & 4\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ 3▦ & 4\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ 3 & ▦4\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ 3 & 4▦\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}1 & ⬚ \\ 3 & 4\end{pmatrix}▦"#, k)
    }


    func test__Move_out_of_an_empty_MatrixNode_to_the_previous_Node_and_back_in()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(DigitNode("2"))
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2))
        Expect.latex(#"2\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        // Act & Assert
        k.moveLeft()
        Expect.latex(#"2▦\begin{pmatrix}⬚ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"2\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
    }


    func test__Delete_content()
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
        // Act & Assert
        k.deleteLeft()
        Expect.latex(#"\begin{pmatrix}1 & 2 \\ 3 & ▦\end{pmatrix}"#, k)
        k.deleteLeft()
        Expect.latex(#"\begin{pmatrix}1 & 2 \\ ▦ & ⬚\end{pmatrix}"#, k)
        k.deleteLeft()
        Expect.latex(#"\begin{pmatrix}1 & ▦ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        k.deleteLeft()
        Expect.latex(#"\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        k.deleteLeft()
        Expect.latex("▦", k)
    }


    func test__MoveRight_MoveDown_MoveLeft_MoveUp()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2))
        Expect.latex(#"\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        // Act & Assert
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}⬚ & ▦ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        k.moveDown()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ⬚ & ▦\end{pmatrix}"#, k)
        k.moveLeft()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ▦ & ⬚\end{pmatrix}"#, k)
        k.moveUp()
        Expect.latex(#"\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
    }


    func test__Impossible_updown_requests_in_an_empty_MatrixNode_should_not_throw()
    {
        // Arrange
        let k = KeyboardMemory()
        k.insert(MatrixNode(matrixType: "pmatrix", width: 2, height: 2))
        Expect.latex(#"\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        // Act & Assert
        k.moveUp()
        Expect.latex(#"\begin{pmatrix}▦ & ⬚ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        k.moveDown()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ▦ & ⬚\end{pmatrix}"#, k)
        k.moveDown()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ▦ & ⬚\end{pmatrix}"#, k)
        k.moveRight()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ⬚ & ▦\end{pmatrix}"#, k)
        k.moveDown()
        Expect.latex(#"\begin{pmatrix}⬚ & ⬚ \\ ⬚ & ▦\end{pmatrix}"#, k)
        k.moveUp()
        Expect.latex(#"\begin{pmatrix}⬚ & ▦ \\ ⬚ & ⬚\end{pmatrix}"#, k)
        k.moveUp()
        Expect.latex(#"\begin{pmatrix}⬚ & ▦ \\ ⬚ & ⬚\end{pmatrix}"#, k)
    }


    func test__Impossible_updown_request_in_filled_MatrixNode_should_not_throw()
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
        // Act & Assert
        k.moveDown()
        Expect.latex(#"\begin{pmatrix}1 & 2 \\ 3 & 4▦\end{pmatrix}"#, k)
        k.moveUp()
        Expect.latex(#"\begin{pmatrix}1 & 2▦ \\ 3 & 4\end{pmatrix}"#, k)
        k.moveUp()
        Expect.latex(#"\begin{pmatrix}1 & 2▦ \\ 3 & 4\end{pmatrix}"#, k)
    }


    func test__GetMoveDownSuggestion_errors_if_it_is_called_for_a_Placeholder_that_is_not_part_of_the_MatrixNode()
    {
        for shouldBeFatal in [true, false] {
            MathKeyboardEngineError.shouldBeFatal = shouldBeFatal
            let matrix = MatrixNode(matrixType: "pmatrix", width: 2, height: 2)
            let placeholderThatIsNotPartOfTheMatrix = Placeholder()
            let act = { return matrix.getMoveDownSuggestion(placeholderThatIsNotPartOfTheMatrix) } 
            if shouldBeFatal {
                XCTAssertTrue(fatalErrorTriggered("The provided Placeholder is not part of this MatrixNode.", { _ = act() }))
            } else {
                XCTAssertNil(act())
            }
        }
    }
}
