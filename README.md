![](https://badgen.net/badge/test%20coverage/97%25/green)
![Swift Version](https://img.shields.io/badge/Swift-5.7-orange.svg)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Platforms](https://img.shields.io/badge/Platform-Linux|macOS|Windows-lightblue.svg)

## MathKeyboardEngine for Swift

MathKeyboardEngine for Swift provides the logic for a highly customizable virtual math keyboard. It is intended for use together with any LaTeX typesetting library (for example [KaTeX](https://katex.org) or [MathJax](https://www.mathjax.org) in a WebView]).

Also available:

- [MathKeyboardEngine for C#](https://github.com/MathKeyboardEngine/MathKeyboardEngine.CSharp#readme).
- [MathKeyboardEngine for JavaScript](https://github.com/MathKeyboardEngine/MathKeyboardEngine#readme).
- [MathKeyboardEngine for Python](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Python#readme).

#### An execution timeline

1. You load a page with your customized virtual math keyboard (based on one of the examples). The keys show typeset LaTeX - loaded form a local png file or rendered on the fly - and a cursor is displayed in a textbox-look-a-like element.
1. On your customized virtual math keyboard, you press a key. The key calls a MathKeyboardEngine function, for example `insert(someMatrixNode)` or `moveUp()`, `deleteLeft()`, etc.
1. Calling `getEditModeLatex()` outputs the total of LaTeX you typed, for example `\frac{3}{4}\blacksquare` (if `\blacksquare` is your cursor), which you then feed to KaTeX or MathJax for display.
1. Calling `getViewModeLatex()` outputs the LaTeX without a cursor.

#### Let me test it now!

Live (JavaScript) examples can be tested at [mathkeyboardengine.github.io](https://mathkeyboardengine.github.io).

#### Pros and cons?

<i>Unique about MathKeyboardEngine:</i>

- it supports (almost?) all math mode LaTeX, including matrices. (Please share if you know anything that is not supported.)
- its syntax tree consists of very few different parts: the `StandardLeafNode`, `StandardBranchingNode`, `AscendingBranchingNode` and `DescendingBranchingNode` can be used for almost all LaTeX, including fractions, powers, combinations, subscript, etc. with ready-to-use up/down/left/right navigation.
- it can be used with any LaTeX math typesetting library you like.

<i>A con:</i>

- this library will never be able to handle setting the cursor with the touch of a finger on a typeset formula. (But it DOES support up/down/left/right navigation and has a selection mode via arrow keys.)

<i>More pros:</i>

- you have full control over what you display on the virtual keyboard keys and what a virtual key press actually does.
- customize the editor output at runtime: dot or comma as decimal separator, cross or dot for multiplication, cursor style, colors, etc.
- this library also supports handling input from a physical keyboard, where - for example - the forward slash "/" key can be programmed to result in encapsulating a previously typed number as the numerator of a fraction. (See the examples.)
- almost forgotten: it's open source, free to use, free to modify (please fork this repo)!

## How to use this library

To use the `MathKeyboardEngine` library in a [SwiftPM project](https://www.swift.org/package-manager), 
add it to the dependencies for your package and - for example - your command-line executable target:

```swift
let package = Package(
    // ...
    dependencies: [
        .package(url: "https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift", from: "0.1.0-alpha.1"),
    ],
    targets: [
        .executableTarget(name: "<my-tool>", dependencies: [
            .product(name: "MathKeyboardEngine", package: "MathKeyboardEngine.Swift"),
        ]),
        // ...
    ]
)
```
For more information, see [swift.org/package-manager](https://www.swift.org/package-manager).

## Documentation

Visit the [documentation](https://mathkeyboardengine.github.io/docs/swift/latest/).

## How to use this repo

Follow these steps to set up (and verify) a development environment for this repository on Windows:

1. Install [Git](https://git-scm.com/downloads), [Swift for Windows](https://www.swift.org/download/), [Visual Studio Community Edition with the C++ Desktop Workload](https://visualstudio.microsoft.com/vs/community/), [VS Code](https://code.visualstudio.com/download) and [Swift for VS Code](https://marketplace.visualstudio.com/items?itemName=sswg.swift-lang).
1. Fork (or clone), checkout and then open the root folder of this repository in VS Code.
1. In the terminal, run `swift test`.
1. Checking code coverage and testing for macOS and Linux in done via [GitHub Actions](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift/actions)- see [.github/workflows](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift/blob/main/.github/workflows/swift.yml).

## Ask or contribute

- [ask questions](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift/discussions) about anything that is not clear or when you'd like help.
- [share](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift/discussions) ideas or what you've made.
- [report a bug](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift/issues).
- [request an enhancement](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift/issues).
- [open a pull request](https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift/pulls).