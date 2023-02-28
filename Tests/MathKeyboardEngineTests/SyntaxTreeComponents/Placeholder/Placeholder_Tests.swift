class Placeholder_Tests : XCTestCase
{
    func test__The_minimum_amount_of_required_space_is_added_by_Placeholder_GetLatex()
    {
        let testCases: [(String, String, String)] = [
            (#"\sin"#, "a", #"\sin a"#),
            (#"\sin"#, "2", #"\sin2"#),
            ("2", #"\pi"#, #"2\pi"#),
            ("a", #"\pi"#, #"a\pi"#),
            (#"\alpha"#, #"\pi"#, #"\alpha\pi"#)
        ]
        for (node1, node2, expectedLatexOutput) in testCases {
            let k = KeyboardMemory()
            k.insert(StandardLeafNode(node1))
            k.insert(StandardLeafNode(node2))
            Expect.viewModeLatex(expectedLatexOutput, k)
        }
    }
}
