
> Extensible - adjective: able to be extended; extendable

# Extensible Swift
An architecture leveraging Swift's protocol-oriented approach to write code that is truly portable across frameworks, libraries, SDKs, and platforms.

### The Challenge
To express code in multiple contexts without rewriting the code, while taking full advantage of the features available in each context.  This challenge requires a system that is flexible in adding to and changing content, on the one hand, and in adding to and changing the modes of expressing content, on the other hand.   

Traditionally, systems have not been able to deliver both capabilities simultaneously.  Usually, a system that can conveniently add a feature is constrained in its ability to add ways of expressing features.  And, systems that can readily add new expressions typically are not able to handle new features easily.

This challenge is sometimes referred to as the [Expression Problem](https://en.wikipedia.org/wiki/Expression_problem).

### The Inspiration
Hats off to Brandon Kase.  Brandon has developed an ingenuous way of leveraging Swift protocols and structs to address the Expression Problem.  His technique enables free-flowings extensibility for both features and modes of expression.

Here, by extensible, I mean extendable by someone other than the person in control of a library, and extendable without having to fork a library down a new path.  Brandon's architecture makes it possible for multiple parties, acting independently of each other, to create protocols extending a library, some by adding features, and others by adding expressions, with the extending protocols theoretically being able to co-exist and interact without central coordination.

The potential is substantial.

For the theory of the Expression Problem, listen to [Brandon's talk at Dot Swift 2018](https://www.dotconferences.com/2018/01/brandon-kase-finally-solving-the-expression-problem).  For a demonstration of the Expression Problem, and a proof of concept for Brandon's solution, see the [two-part SwiftTalk](https://talk.objc.io/episodes/S01E89-extensible-libraries-2-protocol-composition) featuring Brandon with Florian Kugler and Chris Eidhof.

### This Project
This project is another proof of concept.  It follows the outlines of Brandon's architecture, but makes certain adjustments to, among other things, work around limitations in the current state of Swift generics.

The intial project takes the small step of coding string attributes and expressing the same code, first, in each of iOS UIKit and OSX AppKit, and then, as HTML inline styles.  UIKit and AppKit both extend NSAttributedString, which is part of Foundation, each with their own versions of `NSAttributedStringKey` and with their dueling `UIFont`/`NSFont` and `UIColor`/`NSColor` types.  They are similar, but result in different code.  

#### EXStringAttributeDictionary
`EXStringAttributeDictionary` provides a single syntax for creating a dictionary of string attributes, with that syntax being essentially the same as the existing syntax with a bit of functional syntatic sugar in the form of chained `adding(_ key: _ value:)` to build the dictionary.  `EXStringAttributeDictionary` is built on top of `EXColor` and `EXFont`. 

A discussion of `EXStringAttributeDictionary` would be best if preceded by explanations of the simpler cases, `EXColor` and `EXFont`.

#### EXColor
`EXColor` provides a simple mechanism for coding a color using Foundation types.  In particular, `EXColor` takes `Double` for each of its four parameters.  Like `UIFont` and `NSFont`, each of the rgba component values lies in the closed range of 0 to 1.  `EXColor` is expressed through one of three structs:  `UIKitColor` which expresses it as a `UIColor`; `AppKitColor` which expresses it as an `NSColor`; and `CSSColor` which expresses it is as `String` containing a CSS rgba value (e.g., `"rgba(122, 100, 43, 1.0)"` ).  

`EXColor` is a protocol.  It has a three required methods:  a zero-parameter `init()`, a static method `color(red:green:blue:alpha)`, and an instance method `alpha(_ alpha:)`, all of which return `Self` (i.e., some concrete type that conforms to the `EXColor` protocol).  It also provides a number of default convenience static vars that produce pre-set colors (e.g., black, white, red, green and blue).

`UIKitColor`, `AppKitColor` and `CSSColor` all conform to `EXColor`.  They each have a single instance property, `let make:`, which holds a closure.  The signature of the closure stored in `make` varies; thus, `make` is not part of the `EXColor` protocol.  The signature of the `make` closure is `()->UIColor` for `UIKitColor.make`, `()->NSColor` for `AppKitColor.make`, and `()->String` for `CSSColor.make`.

By way of example, the static `color(red:green:blue:alpha)` method on `UIKitColor` (which method is required by the `EXColor` protocol) returns an instance of UIKitColor, with that instance's `make` property holding a closure that, when called, will return an instance of `UIColor`.  The `color` method builds that `UIColor` instance by converting each of the four `Double` values supplied as its parameters into `CGFloat` values, and then supplying those values to the `UIColor` initializer.  The whole is wrapped up as the return value of a closure, and, through a sleight of hand, the closure is supplied as the `make` parameter necessary to initialize the instance of `UIKitColor` which is to be returned by the `color` method.  The resultant code looks pretty, but how its pieces fit together is not immediately obvious.

    public static func color(red: Double, green: Double, blue: Double, alpha: Double) -> UIKitColor {
        return UIKitColor {
            return UIColor(red: red.clamped(to: 0...1).cgFloat, green: green.clamped(to: 0...1).cgFloat, blue: blue.clamped(to: 0...1).cgFloat, alpha: alpha.clamped(to: 0...1).cgFloat)
        }
    }

This formulation for storing `{ return UIColor(...) }` into the `make` property of the same struct is part of Brandon's architecture.  The sleight of hand comes through the combination of (1) Swift auto-generating the struct's `init` method, with (2) Swift's trailing closure syntax, which allows the closure to trail after the parenetheses enclosing the parameters of the `init` method and which allows the omission of the `make` label that otherwise would precede the closure, and (3) the fact of the struct having only one parameter, with that parameter being supplied as a trailing closure, allowing the parentheses to of the `init` method to be omitted entirely.  I'd like to think Brandon went through a few iterations before reaching this state of elegance. 


