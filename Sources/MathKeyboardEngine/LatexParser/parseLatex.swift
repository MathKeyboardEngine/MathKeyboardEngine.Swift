public func parseLatex(_ latex : String?, _ latexParserConfiguration : LatexParserConfiguration = LatexParserConfiguration()) throws -> KeyboardMemory {
    if latex == nil {
        return KeyboardMemory()
    }
    var x = latex!

    let k = KeyboardMemory()

    while x != "" {
        if x[0] == " " {
            x = x[1...]
            continue;
        }

        let decimalSeparatorMatch = latexParserConfiguration.decimalSeparatorMatchers.first { (pattern : String) in x.starts(with: pattern) }
        if decimalSeparatorMatch != nil {
            k.insert(DecimalSeparatorNode(latexParserConfiguration.preferredDecimalSeparator ?? { decimalSeparatorMatch! }))
            x = x[decimalSeparatorMatch!.count...]
            continue;
        }

        if x[0].isNumber || latexParserConfiguration.additionalDigits?.contains(where: { $0 == String(x.first!) }) == true {
            k.insert(DigitNode(String(x.first!)))
            x = x[1...]
            continue
        }

        var handled = false

        if x.starts(with: #"\begin{"#) {
            let matrixTypeAndRest = try x.getBracketPairContent(#"\begin{"#, #"}"#)
            if !matrixTypeAndRest.content.hasSuffix("matrix") && !matrixTypeAndRest.content.hasSuffix("cases") {
                throw MathKeyboardEngineError(#"Expected a word ending with "matrix" or "cases" after "\begin{"."#)
            }
            let matrixContent = matrixTypeAndRest.rest[...matrixTypeAndRest.rest.index(of: "\\end{\(matrixTypeAndRest.content)}")!]
            let lines = matrixContent.split(separator: #"\\"#)
            k.insert(MatrixNode(matrixType: matrixTypeAndRest.content, width: lines[0].split(separator: "&").count, height: lines.count))
            for line in lines {
                for elementLatex in line.split(separator: "&") {
                    let nodes = (try parseLatex(String(elementLatex), latexParserConfiguration)).syntaxTreeRoot.nodes
                    k.insert(nodes.asValueTypeArray)
                    k.moveRight()
                }
            }
            let matrixEnd = "\\end{\(matrixTypeAndRest.content)}";
            x = x[(x.index(of: matrixEnd)!.hashValue + matrixEnd.count)...]
            continue
        }

        if (latexParserConfiguration.preferRoundBracketsNode && (x[0] == "(" || x.starts(with: #"\left("#)))
        {
            let opening = x[0] == "(" ? "(" : #"\left("#
            let closing = x[0] == "(" ? ")" : #"\right)"#
            let bracketsNode = RoundBracketsNode(opening, closing)
            k.insert(bracketsNode)
            let bracketsContentAndRest = try x.getBracketPairContent(opening, closing)
            let bracketsContentNodes = try parseLatex(bracketsContentAndRest.content, latexParserConfiguration).syntaxTreeRoot.nodes
            k.insert(bracketsContentNodes.asValueTypeArray)
            k.current = bracketsNode
            x = bracketsContentAndRest.rest
            continue
        }

        if x.starts(with: #"\"#) {
            for prefixCommand in [#"\left\"#, #"\right\"#, #"\left"#, #"\right"# ] {
                if x.starts(with: prefixCommand) && !x[prefixCommand.count].isLetter {
                    k.insert(StandardLeafNode(prefixCommand + String(x[prefixCommand.count])))
                    x = x[(prefixCommand.count + 1)...];
                    handled = true
                    break
                }
            }
            if handled {
                continue
            }

            let textOpening = #"\text{"#
            if x.starts(with: textOpening) {
                let bracketPairContentAndRest = try x.getBracketPairContent(textOpening, "}")
                let textNode = StandardBranchingNode(textOpening, "}")
                k.insert(textNode)
                for character in bracketPairContentAndRest.content {
                    k.insert(StandardLeafNode(String(character)))
                }
                k.current = textNode
                x = bracketPairContentAndRest.rest
                continue
            }

            var command = #"\"#
            if x[1].isLetter {
                for i in 1..<x.count {
                    let character = x[i]
                    if character.isLetter {
                        command += String(character)
                    } else if character == "{" || character == "[" {
                        let opening = command + String(character)
                        let closingBracket1 = character == "{" ? "}" : "]"
                        let bracketPair1ContentAndRest = try x.getBracketPairContent(opening, closingBracket1)
                        let placeholder1Nodes = try parseLatex(bracketPair1ContentAndRest.content, latexParserConfiguration).syntaxTreeRoot.nodes
                        if bracketPair1ContentAndRest.rest.first == "{" {
                            let multiPlaceholderBranchingNode = DescendingBranchingNode(opening, closingBracket1 + "{", "}")
                            k.insert(multiPlaceholderBranchingNode)
                            k.insert(placeholder1Nodes.asValueTypeArray)
                            k.moveRight()
                            let bracketPair2ContentAndRest = try bracketPair1ContentAndRest.rest.getBracketPairContent("{", "}");
                            let placeholder2Nodes = try parseLatex(bracketPair2ContentAndRest.content, latexParserConfiguration).syntaxTreeRoot.nodes;
                            k.insert(placeholder2Nodes.asValueTypeArray);
                            k.current = multiPlaceholderBranchingNode;
                            x = bracketPair2ContentAndRest.rest;
                        } else {
                            let singlePlaceholderBranchingNode = StandardBranchingNode(opening, closingBracket1)
                            k.insert(singlePlaceholderBranchingNode);
                            k.insert(placeholder1Nodes.asValueTypeArray);
                            k.current = singlePlaceholderBranchingNode;
                            x = bracketPair1ContentAndRest.rest;
                        }
                        handled = true;
                        break
                    } else {
                        break
                    }
                }
                if handled {
                    continue
                }
                k.insert(StandardLeafNode(command))
                x = x[command.count...]
            } else {
                k.insert(StandardLeafNode(#"\"# + String(x[1])))
                x = x[2...]
            }
            continue
        }

        if x.starts(with: "_{") {
            let opening = "_{";
            let closingBracket1 = "}";
            let bracketPair1ContentAndRest = try x.getBracketPairContent(opening, closingBracket1)
            if (bracketPair1ContentAndRest.rest.starts(with: "^{")) {
                let ascendingBranchingNode = AscendingBranchingNode(opening, "}^{", "}")
                k.insert(ascendingBranchingNode)
                let placeholder1Nodes = try parseLatex(bracketPair1ContentAndRest.content, latexParserConfiguration).syntaxTreeRoot.nodes
                k.insert(placeholder1Nodes.asValueTypeArray)
                k.moveRight()
                let bracketPair2ContentAndRest = try bracketPair1ContentAndRest.rest.getBracketPairContent("^{", "}")
                let placeholder2Nodes = try parseLatex(bracketPair2ContentAndRest.content, latexParserConfiguration).syntaxTreeRoot.nodes
                k.insert(placeholder2Nodes.asValueTypeArray)
                k.current = ascendingBranchingNode
                x = bracketPair2ContentAndRest.rest
                continue
            }
        }

        for tuple : (opening : String, node : BranchingNode) in [
                ("^{", AscendingBranchingNode("", "^{", "}")),
                ("_{", DescendingBranchingNode("", "_{", "}"))
        ] {
            if x.starts(with: tuple.opening) {
                k.insertWithEncapsulateCurrent(tuple.node)
                let bracketPairContentAndRest = try x.getBracketPairContent(tuple.opening, "}")
                let secondPlaceholderNodes = try parseLatex(bracketPairContentAndRest.content, latexParserConfiguration).syntaxTreeRoot.nodes
                k.insert(secondPlaceholderNodes.asValueTypeArray)
                k.current = tuple.node
                x = bracketPairContentAndRest.rest
                handled = true
                break
            }
        }
        if handled {
            continue
        }

        k.insert(StandardLeafNode(String(x[0])))
        x = x[1...]
        continue

    }
    return k
}
