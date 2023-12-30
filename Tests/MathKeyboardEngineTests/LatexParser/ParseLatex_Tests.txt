using System;
using System.Collections.Generic;
using Xunit;

namespace MathKeyboardEngine.Tests;

public class LatexParser_Tests
{
    [Theory]
    [InlineData("")]
    [InlineData(" ")]
    [InlineData(null)]
    public void Can_handle_empty_and_null_input(string? input)
    {
        // Act
        var k = Parse.Latex(input);
        // Assert
        Expect.ViewModeLatex("⬚", k);
    }

    [Theory]
    [InlineData(@"1")]
    [InlineData(@"123")]
    [InlineData(@"1.2")]
    [InlineData(@"x")]
    [InlineData(@"xyz")]
    [InlineData(@"2x")]
    [InlineData(@"\frac{1}{2}")]
    [InlineData(@"3\frac{1}{2}")]
    [InlineData(@"\frac{1}{2}3")]
    [InlineData(@"\frac{1+x}{2-y}")]
    [InlineData(@"\frac{7}{\frac{8}{9}}")]
    [InlineData(@"\binom{10}{2}")]
    [InlineData(@"\binom{\frac{4}{2}}{1}")]
    [InlineData(@"\frac{\frac{\binom{10}{x}}{x-1}}{\frac{2a-x}{a}}")]
    [InlineData(@"2^x")]
    [InlineData(@"2^{x}")]
    [InlineData(@"2^{x+1}")]
    [InlineData(@"2^{\frac{1}{2}}")]
    [InlineData(@"1+2^{\frac{3}{4}}+5")]
    [InlineData(@"a_{1}")]
    [InlineData(@"a_1")]
    [InlineData(@"a_{n-1}")]
    [InlineData(@"a_{n-2}a_{n-1}a_{n}")]
    [InlineData(@"x^\frac{1}{2}")]
    [InlineData(@"x^{\frac{1}{2}}")]
    [InlineData(@"x^\frac{p^2}{2}")]
    [InlineData(@"x^\frac{p^{2}}{2}")]
    [InlineData(@"x^\pi")]
    [InlineData(@"x^{\pi}")]
    [InlineData(@"a_1\times a_2")]
    [InlineData(@"a_{1}\times a_{2}")]
    [InlineData(@"\sqrt{2}")]
    [InlineData(@"a\sqrt{2}b")]
    [InlineData(@"\sin\pi")]
    [InlineData(@"\sin{\pi}")]
    [InlineData(@"\|")]
    [InlineData(@"\sin6")]
    [InlineData(@"\sin{6}")]
    [InlineData(@"\sin(6)")]
    [InlineData(@"\sin\left(6\right)")]
    public void ParsesExactly(string input)
    {
        // Act
        var k = Parse.Latex(input);
        // Assert
        Expect.ViewModeLatex(input, k);
    }

    [Fact]
    public void Can_handle_non_decimal_number_base()
    {
        // Arrange
        var myParserConfig = new LatexParserConfiguration
        {
            AdditionalDigits = ["↊", "↋"]
        };
        // Act
        var k = Parse.Latex("6↊↋", myParserConfig);
        // Assert
        foreach (var node in k.SyntaxTreeRoot.Nodes)
        {
            Assert.True(node is DigitNode);
        }

        k.InsertWithEncapsulateCurrent(new DescendingBranchingNode(@"\frac{", "}{", "}"));
        k.Insert(new DigitNode("2"));
        Expect.ViewModeLatex(@"\frac{6↊↋}{2}", k);
    }

    [Fact]
    public void Allows_commands_with_bracket_only_difference()
    {
        // Act & Assert
        Expect.ViewModeLatex(@"\sqrt[3]{27}", Parse.Latex(@"\sqrt[3]{27}"));
        Expect.ViewModeLatex(@"\sqrt{3}{27}", Parse.Latex(@"\sqrt{3}{27}"));
        Expect.ViewModeLatex(@"\sqrt[3][27]", Parse.Latex(@"\sqrt[3][27]"));
        Expect.ViewModeLatex(@"\sqrt{3}[27]", Parse.Latex(@"\sqrt{3}[27]"));
    }

    [Fact]
    public void Throws_on_missing_closing_bracket()
    {
        Assert.ThrowsAny<Exception>(() => Parse.Latex(@"\frac{1}{2"));
    }

    [Theory]
    [InlineData(@"a")]
    [InlineData(@"\|")]
    [InlineData(@"\pi")]
    [InlineData(@"\left{")]
    [InlineData(@"\left\{")]
    [InlineData(@"\right}")]
    [InlineData(@"\right\}")]
    [InlineData(@"\right|")]
    [InlineData(@"\right\|")]
    [InlineData(@"\right]")]
    [InlineData(@"\right\]")]
    [InlineData(@"\left(")]
    [InlineData(@"\right)")]
    public void Expected_StandardLeafNodes(string testData)
    {
        var myParserConfig = new LatexParserConfiguration();
        myParserConfig.PreferRoundBracketsNode = false;
        // Act
        var k = Parse.Latex(testData, myParserConfig);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        var node = Assert.Single(nodes);
        Assert.True(node is StandardLeafNode);
        Expect.ViewModeLatex(testData, k);
    }

    [Theory]
    [InlineData(@"\sin6")]
    [InlineData(@"\sin 6")]
    public void Sinus_and_argument_are_separate_LeafNodes(string testData)
    {
        // Act
        var k = Parse.Latex(testData);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        Assert.Equal(2, nodes.Count);
        Assert.True(nodes[0] is StandardLeafNode);
        Assert.True(nodes[1] is DigitNode);
        Expect.ViewModeLatex(@"\sin6", k);
    }

    [Fact]
    public void Can_understand_sin_as_a_StandardBranchingNode()
    {
        // Arrange
        var latex = @"\sin{6}";
        // Act
        var k = Parse.Latex(latex);
        // Assert
        var outerNode = Assert.Single(k.SyntaxTreeRoot.Nodes) as BranchingNode;
        Assert.True(outerNode is StandardBranchingNode);
        var innerNode = Assert.Single(outerNode!.Placeholders[0].Nodes);
        Assert.True(innerNode is DigitNode);
        Expect.ViewModeLatex(latex, k);
    }

    [Theory]
    [InlineData(".")]
    [InlineData("{,}")]
    public void It_understands_several_decimal_separator_symbols_by_default(string separator)
    {
        // Arrange
        var latex = $"1{separator}2";
        // Act
        var k = Parse.Latex(latex);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        Assert.Equal(3, nodes.Count);
        var separatorNode = nodes[1];
        Assert.True(nodes[0] is DigitNode);
        Assert.True(separatorNode is DecimalSeparatorNode);
        Assert.True(nodes[2] is DigitNode);
        Expect.ViewModeLatex(latex, k);
    }

    [Fact]
    public void It_allows_modifying_the_decimal_separator_even_after_parsing()
    {
        // Arrange
        var preferredDecimalSeparator = "{,}";
        var myParserConfig = new LatexParserConfiguration
        {
            PreferredDecimalSeparator = () => preferredDecimalSeparator
        };
        // Act 1
        var k = Parse.Latex("1.2", myParserConfig);
        // Assert 1
        Expect.ViewModeLatex("1{,}2", k);
        // Act 2
        preferredDecimalSeparator = ",";
        // Assert 2
        Expect.ViewModeLatex("1,2", k);
    }

    [Fact]
    public void It_understands_that_subscripts_can_be_DescendingBranchingNodes()
    {
        // Arrange
        var latex = @"a_{12}\times a_{34}";
        // Act
        var k = Parse.Latex(latex);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        Assert.Equal(3, nodes.Count);

        var outerNode = nodes[0] as BranchingNode;
        Assert.True(outerNode is DescendingBranchingNode);
        var subscript1 = outerNode!.Placeholders[1].Nodes;
        Assert.Equal(2, subscript1.Count);
        Assert.True(subscript1[0] is DigitNode);
        Assert.True(subscript1[1] is DigitNode);

        Assert.True(nodes[1] is StandardLeafNode);

        var outerNode2 = nodes[0] as BranchingNode;
        Assert.True(outerNode2 is DescendingBranchingNode);
        var subscript2 = outerNode2!.Placeholders[1].Nodes;
        Assert.Equal(2, subscript2.Count);
        Assert.True(subscript2[0] is DigitNode);
        Assert.True(subscript2[1] is DigitNode);

        Expect.ViewModeLatex(latex, k);
    }

    [Fact]
    public void It_understands_complex_Latex()
    {
        // Arrange
        var latex = @"\exp\left[\int d^{4}xg\phi\bar{\psi}\psi\right]=\sum_{n=0}^{\infty}\frac{g^{n}}{n!}\left(\int d^{4}x\phi\bar{\psi}\psi\right)^{n}";
        // Act
        var myParserConfig = new LatexParserConfiguration
        {
            PreferRoundBracketsNode = false
        };
        var k = Parse.Latex(latex, myParserConfig);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;

        Assert.True(nodes[0] is StandardLeafNode);
        Expect.ViewModeLatex(@"\exp", nodes[0]);

        Assert.True(nodes[1] is StandardLeafNode);
        Expect.ViewModeLatex(@"\left[", nodes[1]);

        Assert.True(nodes[2] is StandardLeafNode);
        Expect.ViewModeLatex(@"\int", nodes[2]);

        Assert.True(nodes[3] is AscendingBranchingNode);
        Expect.ViewModeLatex("d^{4}", nodes[3]);

        Assert.True(nodes[4] is StandardLeafNode);
        Expect.ViewModeLatex("x", nodes[4]);

        Assert.True(nodes[5] is StandardLeafNode);
        Expect.ViewModeLatex("g", nodes[5]);

        Assert.True(nodes[6] is StandardLeafNode);
        Expect.ViewModeLatex(@"\phi", nodes[6]);

        Assert.True(nodes[7] is StandardBranchingNode);
        Expect.ViewModeLatex(@"\bar{\psi}", nodes[7]);

        Assert.True(nodes[8] is StandardLeafNode);
        Expect.ViewModeLatex(@"\psi", nodes[8]);

        Assert.True(nodes[9] is StandardLeafNode);
        Expect.ViewModeLatex(@"\right]", nodes[9]);

        Assert.True(nodes[10] is StandardLeafNode);
        Expect.ViewModeLatex("=", nodes[10]);

        Assert.True(nodes[11] is StandardLeafNode);
        Expect.ViewModeLatex(@"\sum", nodes[11]);

        Assert.True(nodes[12] is AscendingBranchingNode);
        Expect.ViewModeLatex(@"_{n=0}^{\infty}", nodes[12]);

        Assert.True(nodes[13] is DescendingBranchingNode);
        Expect.ViewModeLatex(@"\frac{g^{n}}{n!}", nodes[13]);

        Assert.True(nodes[14] is StandardLeafNode);
        Expect.ViewModeLatex(@"\left(", nodes[14]);

        Assert.True(nodes[15] is StandardLeafNode);
        Expect.ViewModeLatex(@"\int", nodes[15]);

        Assert.True(nodes[16] is AscendingBranchingNode);
        Expect.ViewModeLatex("d^{4}", nodes[16]);

        Assert.True(nodes[17] is StandardLeafNode);
        Expect.ViewModeLatex("x", nodes[17]);

        Assert.True(nodes[18] is StandardLeafNode);
        Expect.ViewModeLatex(@"\phi", nodes[18]);

        Assert.True(nodes[19] is StandardBranchingNode);
        Expect.ViewModeLatex(@"\bar{\psi}", nodes[19]);

        Assert.True(nodes[20] is StandardLeafNode);
        Expect.ViewModeLatex(@"\psi", nodes[20]);

        Assert.True(nodes[21] is AscendingBranchingNode);
        Expect.ViewModeLatex(@"\right)^{n}", nodes[21]);

        Expect.ViewModeLatex(latex, k);
    }

    [Theory]
    [InlineData("matrix")]
    [InlineData("pmatrix")]
    public void It_understands_all_matrix_types(string matrixType)
    {
        // Arrange
        var latex = @"3\begin{" + matrixType + @"}1+2 & x^{3} \\ \frac{4}{5} & x \\ \pi & x\left(x+6\right)\end{" + matrixType + "}=";
        // Act
        var k = Parse.Latex(latex);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        Assert.Equal(3, nodes.Count);
        Assert.True(nodes[0] is DigitNode);
        Assert.True(nodes[1] is MatrixNode);
        Assert.True(nodes[2] is StandardLeafNode);

        var matrixNode = nodes[1] as MatrixNode;
        Assert.Equal(6, matrixNode!.Placeholders.Count);

        var placeholder0 = matrixNode.Placeholders[0];
        Assert.Equal(3, placeholder0.Nodes.Count);
        Expect.ViewModeLatex("1+2", placeholder0);

        var placeholder1 = matrixNode.Placeholders[1];
        var placeholder1Node = Assert.Single(placeholder1.Nodes);
        Expect.ViewModeLatex("x^{3}", placeholder1);
        Assert.True(placeholder1Node is AscendingBranchingNode);

        var placeholder2 = matrixNode.Placeholders[2];
        var placeholder2Node = Assert.Single(placeholder2.Nodes);
        Assert.True(placeholder2Node is DescendingBranchingNode);
        Expect.ViewModeLatex(@"\frac{4}{5}", placeholder2);

        Expect.ViewModeLatex("x", Assert.Single(matrixNode.Placeholders[3].Nodes));

        Expect.ViewModeLatex(@"\pi", Assert.Single(matrixNode.Placeholders[4].Nodes));

        var placeholder5 = matrixNode.Placeholders[5];
        Assert.Equal(2, placeholder5.Nodes.Count);
        Expect.ViewModeLatex(@"x\left(x+6\right)", placeholder5);

        Expect.ViewModeLatex(latex, k);
    }

    [Fact]
    public void It_parses_begincases_and_text()
    {
        // Arrange
        var latex = @"x=\begin{cases}a & \text{if }b \\ c & \text{if }d\end{cases}";
        // Act
        var k = Parse.Latex(latex);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        Assert.Equal(3, nodes.Count);
        Assert.True(nodes[2] is MatrixNode);
        var matrixNode = nodes[2] as MatrixNode;
        Assert.Equal(4, matrixNode!.Placeholders.Count);
        var placeholder1 = matrixNode.Placeholders[1];
        Assert.Equal(2, placeholder1.Nodes.Count);
        Expect.ViewModeLatex(@"\text{if }", placeholder1.Nodes[0]);
        Expect.ViewModeLatex(latex, k);
    }

    [Fact]
    public void It_throws_if_begin_does_not_contain_the_word_matrix_or_cases()
    {
        var ex = Assert.ThrowsAny<Exception>(() => Parse.Latex(@"\begin{test}12\\34\end{test}"));
        Assert.Equal("""Expected a word ending with "matrix" or "cases" after "\begin{".""", ex.Message);
    }

    [Theory]
    [InlineData("(x-1)")]
    [InlineData(@"\left(x-1\right)")]
    public void LatexParserConfiguration_PreferRoundBracketsNode(string latex)
    {
        // Arrange
        var myParserConfig = new LatexParserConfiguration
        {
            PreferRoundBracketsNode = true
        };
        // Act
        var k = Parse.Latex(latex, myParserConfig);
        // Assert
        var node = Assert.Single(k.SyntaxTreeRoot.Nodes);
        Assert.True(node is RoundBracketsNode);
        var roundBracketsNode = node as RoundBracketsNode;
        Expect.ViewModeLatex(latex, k);
        Assert.Equal(3, roundBracketsNode!.Placeholders[0].Nodes.Count);
    }

    [Fact]
    public void It_parses_lim_correctly()
    {
        // Arrange
        var latex = @"\lim_{x\rightarrow\infty}x";
        // Act
        var k = Parse.Latex(latex);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        Assert.Equal(2, nodes.Count);

        Assert.True(nodes[0] is DescendingBranchingNode);
        var limitNode = nodes[0] as DescendingBranchingNode;
        Assert.Equal(2, limitNode!.Placeholders.Count);

        Assert.True(nodes[1] is StandardLeafNode);

        Expect.ViewModeLatex(latex, k);
    }

    [Fact]
    public void It_parses_sum_correctly()
    {
        // Arrange
        var latex = @"\sum_{0}^{\infty}";
        // Act
        var k = Parse.Latex(latex);
        // Assert
        var nodes = k.SyntaxTreeRoot.Nodes;
        Assert.Equal(2, nodes.Count);
        Assert.True(nodes[0] is StandardLeafNode);
        Expect.ViewModeLatex(@"\sum", nodes[0]);
        Assert.True(nodes[1] is AscendingBranchingNode);
        var sumNode = nodes[1] as AscendingBranchingNode;
        Expect.ViewModeLatex(@"_{0}^{\infty}", nodes[1]);
        Assert.Equal(2, sumNode!.Placeholders.Count);
        Assert.True(sumNode.Placeholders[0].Nodes[0] is DigitNode);
        Assert.True(sumNode.Placeholders[1].Nodes[0] is StandardLeafNode);
        Expect.ViewModeLatex(latex, k);

    }
}
