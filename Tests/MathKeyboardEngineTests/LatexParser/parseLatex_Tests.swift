class LatexParser_Tests : XCTestCase
{
    func test__Can_handle_empty_and_null_input() throws
    {
        for input in ["", " ", nil] {
            // Act
            let k = try parseLatex(input)
            // Assert
            Expect.viewModeLatex("⬚", k)
        }
    }

    func test__ParsesExactly() throws
    {
        for input in [
            #"1"#,
            #"123"#,
            #"1.2"#,
            #"x"#,
            #"xyz"#,
            #"2x"#,
            #"\frac{1}{2}"#,
            #"3\frac{1}{2}"#,
            #"\frac{1}{2}3"#,
            #"\frac{1+x}{2-y}"#,
            #"\frac{7}{\frac{8}{9}}"#,
            #"\binom{10}{2}"#,
            #"\binom{\frac{4}{2}}{1}"#,
            #"\frac{\frac{\binom{10}{x}}{x-1}}{\frac{2a-x}{a}}"#,
            #"2^x"#,
            #"2^{x}"#,
            #"2^{x+1}"#,
            #"2^{\frac{1}{2}}"#,
            #"1+2^{\frac{3}{4}}+5"#,
            #"a_{1}"#,
            #"a_1"#,
            #"a_{n-1}"#,
            #"a_{n-2}a_{n-1}a_{n}"#,
            #"x^\frac{1}{2}"#,
            #"x^{\frac{1}{2}}"#,
            #"x^\frac{p^2}{2}"#,
            #"x^\frac{p^{2}}{2}"#,
            #"x^\pi"#,
            #"x^{\pi}"#,
            #"a_1\times a_2"#,
            #"a_{1}\times a_{2}"#,
            #"\sqrt{2}"#,
            #"a\sqrt{2}b"#,
            #"\sin\pi"#,
            #"\sin{\pi}"#,
            #"\|"#,
            #"\sin6"#,
            #"\sin{6}"#,
            #"\sin(6)"#,
            #"\sin\left(6\right)"#
        ] {
            // Act
            let k = try parseLatex(input)
            // Assert
            Expect.viewModeLatex(input, k)
        }
    }

    func test__Can_handle_non_decimal_number_base() throws
    {
        // Arrange
        let myParserConfig = LatexParserConfiguration()
        myParserConfig.additionalDigits = ["↊", "↋"]
        // Act
        let k = try parseLatex("6↊↋", myParserConfig)
        // Assert
        for node in k.syntaxTreeRoot.nodes.asValueTypeArray {
            XCTAssertTrue(node is DigitNode)
        }

        k.insertWithEncapsulateCurrent(DescendingBranchingNode(#"\frac{"#, "}{", "}"))
        k.insert(DigitNode("2"))
        Expect.viewModeLatex(#"\frac{6↊↋}{2}"#, k)
    }

    func test__Allows_commands_with_bracket_only_difference() throws
    {
        // Act & Assert
        Expect.viewModeLatex(#"\sqrt[3]{27}"#, try parseLatex(#"\sqrt[3]{27}"#))
        Expect.viewModeLatex(#"\sqrt{3}{27}"#, try parseLatex(#"\sqrt{3}{27}"#))
        Expect.viewModeLatex(#"\sqrt[3][27]"#, try parseLatex(#"\sqrt[3][27]"#))
        Expect.viewModeLatex(#"\sqrt{3}[27]"#, try parseLatex(#"\sqrt{3}[27]"#))
    }

    func test__Throws_on_missing_closing_bracket() throws
    {
        do {
            _ = try parseLatex(#"\frac{1}{2"#)
        } catch is MathKeyboardEngineError {
            return
        }
        XCTAssertTrue(false)
    }

    func test__Expected_StandardLeafNodes() throws
    {
        for testData in [
            #"a"#,
            #"\|"#,
            #"\pi"#,
            #"\left{"#,
            #"\left\{"#,
            #"\right}"#,
            #"\right\}"#,
            #"\right|"#,
            #"\right\|"#,
            #"\right]"#,
            #"\right\]"#,
            #"\left("#,
            #"\right)"#
        ] {
            let myParserConfig = LatexParserConfiguration()
            myParserConfig.preferRoundBracketsNode = false
            // Act
            let k = try parseLatex(testData, myParserConfig)
            // Assert
            let nodes = k.syntaxTreeRoot.nodes
            XCTAssertEqual(1, nodes.count)
            XCTAssertTrue(nodes[0] is StandardLeafNode)
            Expect.viewModeLatex(testData, k)
        }
    }

    func test__Sinus_and_argument_are_separate_LeafNodes() throws
    {
        for testData in [
            #"\sin6"#,
            #"\sin 6"#
        ] {
            // Act
            let k = try parseLatex(testData)
            // Assert
            let nodes = k.syntaxTreeRoot.nodes
            XCTAssertEqual(2, nodes.count)
            XCTAssertTrue(nodes[0] is StandardLeafNode)
            XCTAssertTrue(nodes[1] is DigitNode)
            Expect.viewModeLatex(#"\sin6"#, k)
        }
    }

    func test__Can_understand_sin_as_a_StandardBranchingNode() throws
    {
        // Arrange
        let latex = #"\sin{6}"#
        // Act
        let k = try parseLatex(latex)
        // Assert
        XCTAssertEqual(1, k.syntaxTreeRoot.nodes.count)
        let outerNode = k.syntaxTreeRoot.nodes[0] as? StandardBranchingNode
        XCTAssertNotNil(outerNode)
        let innerNodes = outerNode!.placeholders[0].nodes
        XCTAssertEqual(1, innerNodes.count)
        XCTAssertTrue(innerNodes[0] is DigitNode)
        Expect.viewModeLatex(latex, k)
    }

    func test__It_understands_several_decimal_separator_symbols_by_default() throws
    {
        for separator in [
            ".",
            "{,}"
        ] {
            // Arrange
            let latex = "1\(separator)2"
            // Act
            let k = try parseLatex(latex)
            // Assert
            let nodes = k.syntaxTreeRoot.nodes
            XCTAssertEqual(3, nodes.count)
            let separatorNode = nodes[1]
            XCTAssertTrue(nodes[0] is DigitNode)
            XCTAssertTrue(separatorNode is DecimalSeparatorNode)
            XCTAssertTrue(nodes[2] is DigitNode)
            Expect.viewModeLatex(latex, k)
        }
    }

    func test__It_allows_modifying_the_decimal_separator_even_after_parsing() throws
    {
        // Arrange
        var preferredDecimalSeparator = "{,}"
        let myParserConfig = LatexParserConfiguration()
        myParserConfig.preferredDecimalSeparator = { preferredDecimalSeparator }
        // Act 1
        let k = try parseLatex("1.2", myParserConfig)
        // Assert 1
        Expect.viewModeLatex("1{,}2", k)
        // Act 2
        preferredDecimalSeparator = ","
        // Assert 2
        Expect.viewModeLatex("1,2", k)
    }

    func test__It_understands_that_subscripts_can_be_DescendingBranchingNodes() throws
    {
        // Arrange
        let latex = #"a_{12}\times a_{34}"#
        // Act
        let k = try parseLatex(latex)
        // Assert
        let nodes = k.syntaxTreeRoot.nodes
        XCTAssertEqual(3, nodes.count)

        let outerNode = nodes[0] as! BranchingNode
        XCTAssertTrue(outerNode is DescendingBranchingNode)
        let subscript1 = outerNode.placeholders[1].nodes
        XCTAssertEqual(2, subscript1.count)
        XCTAssertTrue(subscript1[0] is DigitNode)
        XCTAssertTrue(subscript1[1] is DigitNode)

        XCTAssertTrue(nodes[1] is StandardLeafNode)

        let outerNode2 = nodes[0] as! BranchingNode
        XCTAssertTrue(outerNode2 is DescendingBranchingNode)
        let subscript2 = outerNode2.placeholders[1].nodes
        XCTAssertEqual(2, subscript2.count)
        XCTAssertTrue(subscript2[0] is DigitNode)
        XCTAssertTrue(subscript2[1] is DigitNode)

        Expect.viewModeLatex(latex, k)
    }

    func test__It_understands_complex_Latex() throws
    {
        // Arrange
        let latex = #"\exp\left[\int d^{4}xg\phi\bar{\psi}\psi\right]=\sum_{n=0}^{\infty}\frac{g^{n}}{n!}\left(\int d^{4}x\phi\bar{\psi}\psi\right)^{n}"#
        // Act
        let myParserConfig = LatexParserConfiguration()
        myParserConfig.preferRoundBracketsNode = false

        let k = try parseLatex(latex, myParserConfig)
        // Assert
        let nodes = k.syntaxTreeRoot.nodes

        XCTAssertTrue(nodes[0] is StandardLeafNode)
        Expect.viewModeLatex(#"\exp"#, nodes[0])

        XCTAssertTrue(nodes[1] is StandardLeafNode)
        Expect.viewModeLatex(#"\left["#, nodes[1])

        XCTAssertTrue(nodes[2] is StandardLeafNode)
        Expect.viewModeLatex(#"\int"#, nodes[2])

        XCTAssertTrue(nodes[3] is AscendingBranchingNode)
        Expect.viewModeLatex("d^{4}", nodes[3])

        XCTAssertTrue(nodes[4] is StandardLeafNode)
        Expect.viewModeLatex("x", nodes[4])

        XCTAssertTrue(nodes[5] is StandardLeafNode)
        Expect.viewModeLatex("g", nodes[5])

        XCTAssertTrue(nodes[6] is StandardLeafNode)
        Expect.viewModeLatex(#"\phi"#, nodes[6])

        XCTAssertTrue(nodes[7] is StandardBranchingNode)
        Expect.viewModeLatex(#"\bar{\psi}"#, nodes[7])

        XCTAssertTrue(nodes[8] is StandardLeafNode)
        Expect.viewModeLatex(#"\psi"#, nodes[8])

        XCTAssertTrue(nodes[9] is StandardLeafNode)
        Expect.viewModeLatex(#"\right]"#, nodes[9])

        XCTAssertTrue(nodes[10] is StandardLeafNode)
        Expect.viewModeLatex("=", nodes[10])

        XCTAssertTrue(nodes[11] is StandardLeafNode)
        Expect.viewModeLatex(#"\sum"#, nodes[11])

        XCTAssertTrue(nodes[12] is AscendingBranchingNode)
        Expect.viewModeLatex(#"_{n=0}^{\infty}"#, nodes[12])

        XCTAssertTrue(nodes[13] is DescendingBranchingNode)
        Expect.viewModeLatex(#"\frac{g^{n}}{n!}"#, nodes[13])

        XCTAssertTrue(nodes[14] is StandardLeafNode)
        Expect.viewModeLatex(#"\left("#, nodes[14])

        XCTAssertTrue(nodes[15] is StandardLeafNode)
        Expect.viewModeLatex(#"\int"#, nodes[15])

        XCTAssertTrue(nodes[16] is AscendingBranchingNode)
        Expect.viewModeLatex("d^{4}", nodes[16])

        XCTAssertTrue(nodes[17] is StandardLeafNode)
        Expect.viewModeLatex("x", nodes[17])

        XCTAssertTrue(nodes[18] is StandardLeafNode)
        Expect.viewModeLatex(#"\phi"#, nodes[18])

        XCTAssertTrue(nodes[19] is StandardBranchingNode)
        Expect.viewModeLatex(#"\bar{\psi}"#, nodes[19])

        XCTAssertTrue(nodes[20] is StandardLeafNode)
        Expect.viewModeLatex(#"\psi"#, nodes[20])

        XCTAssertTrue(nodes[21] is AscendingBranchingNode)
        Expect.viewModeLatex(#"\right)^{n}"#, nodes[21])

        Expect.viewModeLatex(latex, k)
    }

    func test__It_understands_all_matrix_types() throws
    {
        for matrixType in [
            "matrix",
            "pmatrix"
        ] {
            // Arrange
            let latex = #"3\begin{"# + matrixType + #"}1+2 & x^{3} \\ \frac{4}{5} & x \\ \pi & x\left(x+6\right)\end{"# + matrixType + "}="
            // Act
            let k = try parseLatex(latex)
            // Assert
            let nodes = k.syntaxTreeRoot.nodes
            XCTAssertEqual(3, nodes.count)
            XCTAssertTrue(nodes[0] is DigitNode)
            XCTAssertTrue(nodes[1] is MatrixNode)
            XCTAssertTrue(nodes[2] is StandardLeafNode)

            let matrixNode = nodes[1] as! MatrixNode
            XCTAssertEqual(6, matrixNode.placeholders.count)

            let placeholder0 = matrixNode.placeholders[0]
            XCTAssertEqual(3, placeholder0.nodes.count)
            Expect.viewModeLatex("1+2", placeholder0)

            let placeholder1 = matrixNode.placeholders[1]
            XCTAssertEqual(1, placeholder1.nodes.count)
            XCTAssertTrue(placeholder1.nodes[0] is AscendingBranchingNode)
            Expect.viewModeLatex("x^{3}", placeholder1)

            let placeholder2 = matrixNode.placeholders[2]
            XCTAssertEqual(1, placeholder2.nodes.count)
            let placeholder2Node = placeholder2.nodes[0]
            XCTAssertTrue(placeholder2Node is DescendingBranchingNode)
            Expect.viewModeLatex(#"\frac{4}{5}"#, placeholder2)

            XCTAssertEqual(1, matrixNode.placeholders[3].nodes.count)
            Expect.viewModeLatex("x", matrixNode.placeholders[3].nodes[0])

            XCTAssertEqual(1, matrixNode.placeholders[4].nodes.count)
            Expect.viewModeLatex(#"\pi"#, matrixNode.placeholders[4].nodes[0])

            let placeholder5 = matrixNode.placeholders[5]
            XCTAssertEqual(2, placeholder5.nodes.count)
            Expect.viewModeLatex(#"x\left(x+6\right)"#, placeholder5)

            Expect.viewModeLatex(latex, k)
        }
    }

    func test__It_parses_begincases_and_text() throws
    {
        // Arrange
        let latex = #"x=\begin{cases}a & \text{if }b \\ c & \text{if }d\end{cases}"#
        // Act
        let k = try parseLatex(latex)
        // Assert
        let nodes = k.syntaxTreeRoot.nodes
        XCTAssertEqual(3, nodes.count)
        XCTAssertTrue(nodes[2] is MatrixNode)
        let matrixNode = nodes[2] as! MatrixNode
        XCTAssertEqual(4, matrixNode.placeholders.count)
        let placeholder1 = matrixNode.placeholders[1]
        XCTAssertEqual(2, placeholder1.nodes.count)
        Expect.viewModeLatex(#"\text{if }"#, placeholder1.nodes[0])
        Expect.viewModeLatex(latex, k)
    }

    func test__It_throws_if_begin_does_not_contain_the_word_matrix_or_cases() throws
    {
        do {
            _ = try parseLatex(#"\begin{test}12\\34\end{test}"#)
        }
        catch let error as MathKeyboardEngineError {
            XCTAssertEqual(#"Expected a word ending with "matrix" or "cases" after "\begin{"."#, error.message)
            return
        }
        XCTAssertTrue(false)
    }

    func test__LatexParserConfiguration_PreferRoundBracketsNode() throws
    {
        for latex in [
            "(x-1)",
            #"\left(x-1\right)"#
        ] {
            // Arrange
            let myParserConfig = LatexParserConfiguration()
            myParserConfig.preferRoundBracketsNode = true
            // Act
            let k = try parseLatex(latex, myParserConfig)
            // Assert
            XCTAssertEqual(1, k.syntaxTreeRoot.nodes.count)
            let node = k.syntaxTreeRoot.nodes[0]
            XCTAssertTrue(node is RoundBracketsNode)
            let roundBracketsNode = node as! RoundBracketsNode
            Expect.viewModeLatex(latex, k)
            XCTAssertEqual(3, roundBracketsNode.placeholders[0].nodes.count)
        }
    }

    func test__It_parses_lim_correctly() throws
    {
        // Arrange
        let latex = #"\lim_{x\rightarrow\infty}x"#
        // Act
        let k = try parseLatex(latex)
        // Assert
        let nodes = k.syntaxTreeRoot.nodes
        XCTAssertEqual(2, nodes.count)

        XCTAssertTrue(nodes[0] is DescendingBranchingNode)
        let limitNode = nodes[0] as! DescendingBranchingNode
        XCTAssertEqual(2, limitNode.placeholders.count)

        XCTAssertTrue(nodes[1] is StandardLeafNode)

        Expect.viewModeLatex(latex, k)
    }

    func test__It_parses_sum_correctly() throws
    {
        // Arrange
        let latex = #"\sum_{0}^{\infty}"#
        // Act
        let k = try parseLatex(latex)

        // Assert
        let nodes = k.syntaxTreeRoot.nodes
        XCTAssertEqual(2, nodes.count)
        XCTAssertTrue(nodes[0] is StandardLeafNode)
        Expect.viewModeLatex(#"\sum"#, nodes[0])
        XCTAssertTrue(nodes[1] is AscendingBranchingNode)
        let sumNode = nodes[1] as! AscendingBranchingNode
        Expect.viewModeLatex(#"_{0}^{\infty}"#, nodes[1])
        XCTAssertEqual(2, sumNode.placeholders.count)
        XCTAssertTrue(sumNode.placeholders[0].nodes[0] is DigitNode)
        XCTAssertTrue(sumNode.placeholders[1].nodes[0] is StandardLeafNode)
        Expect.viewModeLatex(latex, k)
    }
}
