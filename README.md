
> Extensible - adjective: able to be extended; extendable

# Extensible Swift
An architecture leveraging Swift's protocol-oriented approach to write code that is truly portable across frameworks, libraries, SDKs, and platforms.

### The Challenge
To express code in multiple contexts without rewriting the code, while taking full advantage of the features available in each context.  This challenge requires a system that is flexible in adding to and changing content, on the one hand, and in adding to and changing the modes of expressing content, on the other hand.   

Traditionally, systems have not been able to deliver both capabilities simultaneously.  Usually, a system that can conveniently add a feature is constrained in its ability to add ways of expressing features.  And, systems that can readily add new expressions typically are not able to handle new features easily.

This challenge is sometimes referred to as the [Expression Problem](https://en.wikipedia.org/wiki/Expression_problem).

### The Inspiration
Hats off to [Brandon Kase](http://bkase.com).  Brandon has developed an ingenuous way of leveraging Swift protocols and structs to address the Expression Problem.  His technique enables free-flowings extensibility for both features and modes of expression.

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

This formulation for storing `{ return UIColor(...) }` into the `make` property of the same struct is part of Brandon's architecture.  The sleight of hand comes through the combination of (1) Swift auto-generating the struct's `init` method, with (2) Swift's trailing closure syntax, which allows the closure to trail after the parenetheses enclosing the parameters of the `init` method and which allows the omission of the `make` label that otherwise would precede the closure, and (3) the fact of the struct having only one parameter, with that parameter being supplied as a trailing closure, allowing the parentheses of the `init` method to be omitted entirely.  I'd like to think Brandon went through a few iterations before reaching this state of elegance. 

After the `color` method is called and the instance of `UIKitColor` is returned, the call to the closure stored in `make` can be made immediately or, later, when convenient.  Calling the closure in the `make` property produces the desired instance of `UIColor`, which then can be used and consumed.

Most directly, the manufacture of a `UIColor` would be formulated as `let color = UIKitColor.color(red: 0.5, green: 0.2, blue: 0.8, alpha: 1).make()`.  That formulation would miss the point.

Most abstractly, it might be written as a generic function:

    func createColor<Color: EXColor>() -> Color {
        return Color.color(red: 0.5, green: 0.2, blue: 0.8, alpha: 1)
    }
    
    let color: UIKitColor = createColor().make()

The proof-of-concept example offered by Brandon in the SwiftTalk video followed the same formulation.  By way of the declaration of `color` as type `UIKitColor`, the compiler is given the information necessary to infer that the generic type of `Color` used in the `createColor` function is also of type `UIKitColor`.  In this fashion, the body of the `createColor` function fully describes the color that is to be created in terms of the `ExColor` protocol, without need of specifying which expression will be used (i.e., the `UIKitColor` expression, the `AppKitColor` expression, the `CSSColor` expression, or some future expression).  Thus, the  `createColor` function can be re-used in any of those contexts without any editing.

Of course, having one's color object wrapped inside a generic function is not especially convenient or pretty.  A middle approach is needed; less abstract, while still being re-usable.  In the playgrounds accompanying this project, I offer a middle approach:  a typealias.  The code is written once, and, when a desired expression is chosen, the typealias is set to match.

    typealias Color = UIKitColor
    ...
    view.backgroundColor = Color.white.make()
    
Depending on the use case, the typealias might be set globally for a project, globally within a framework, within a file scope, within the scope of a type, or inside a function.    

#### Extending EXColor
The true power of this architecture is its extensibility.  That power is seen when considering obvious cases for extending the `EXColor` library to add a `CoreGraphicsColor` expression and a `pink` static variable feature.

##### CoreGraphicsColor Expression of EXColor
The new expression is accomplished by creating a new struct, and conforming it to the `EXColor` protocol.  Xcode does most of the heavy lifting for us by supplying the required method signatures, and we supply a couple of lines of code to complete the method bodies. 

    public struct CoreGraphicsColor {
        public var make: () -> CGColor
    }

    extension CoreGraphicsColor: EXColor {
        public init() {
            make = { return .white }
        }

        public static func color(red: Double, green: Double, blue: Double, alpha: Double) -> CoreGraphicsColor {
            return CoreGraphicsColor {
                return CGColor(red: red.clamped(to: 0...1).cgFloat, green: green.clamped(to: 0...1).cgFloat, blue: blue.clamped(to: 0...1).cgFloat, alpha: alpha.clamped(to: 0...1).cgFloat)
            }
        }

        public func alpha(_ alpha: Double) -> CoreGraphicsColor {
            return CoreGraphicsColor {
                return self.make().withAlphaComponent(alpha.cgFloat)
            }
        }
    }

As Brandon suggests, a new expression, like this expression of `EXColor`, could be published by its author as a mini-library that extends the `EXColor` library.  There is no need to fork the original `EXColor` library.  The `CoreGraphicsColor` mini-library can be published and distributed separately.  The only dependency, here, is the core of the protocol definition itself.  The core definition of the `EXColor` protocol--its three method requirements--ought not change.  If the core is changed, it would be breaking for library extensions created by others.  Otherwise, the protocol in the original library can  be extended easily and safely (see, pink, below), whether as part of the original library or via other libraries.  Those extensions do not interefere with anything in the CoreGraphicsColor struct or any of the other structs that express `EXColor` (at least, probably not, except for possible compiler idiosyncracies that might result from naming collisions in extensions).

##### Pink Feature of EXColor Protocol
The new feature is accomplished by extending the `EXColor` protocol.  The nuance to adding feature is that it ought to call back into one of the required methods at the core of the protocol.  Doing so allows the new feature to connect to the expression mechanisms.  There may be other ways for a new feature to interact with the protocol (other than calling to one of the required methods), but I have not explored that question at any depth.[^1]    

In this case, our `pink` static variable calls back to the required `color` method.

    public static var pink: Self {
        return Self.color(red: 0.9, green: 0.4, blue: 0.9, alpha: 1)
    }

The hook provided by calling back to a required method is another core component of this architecture.  It allows an entirely new feature to be added to the original library or from outside the original library.  Neither the original expression structs nor any new expression structs need know anything about the new feature.  It is the responsibility of the new feature to manipulate itself into a state that can be expressed via one of the existing required methods.  Once reaching that state, the expression structs can handle the new feature.

Alternatively, an entirely new featue that may not be capable of hooking into an exisitng required method could be added to the system as a required method on a new protocol that conforms to the original protocol.  That new protocol could be used side-by-side with the original protocol wherever the new feature is desired.  

More precisely, to take advantage of a new feature added via a new protocal while using an existing expression struct, the existing expression struct would be extended to conform to the requirements of the new protocol (i.e., most likely, adding a method in an extension of the struct).

As an example, polk-a-dots might be added as new feature to `UIColor`, and thus as a new feature to `EXColor`, as follows:

    public protocol EXPolkaDottedColor: EXColor {
        func addDots(dotColor: Self, dotDiameter: Double, dotSpacing: Double) -> Self
    }

In which case, `UIKitColor` would be extended:

    extension UIKitColor: EXPolkaDottedColor {
        public func addDots(dotColor: Self, dotDiameter: Double, dotSpacing: Double) -> UIKitColor {
            return UIKitColor {
                ... // make a polk-a-dotted UIColor
            }
        }
    }

In that sort of case--a feature that is expressible in one or more expression contexts but perhaps not others--there surely is an art to decisions of how to fallback and/or fail.  One type-safe approach suggested by Chris Eidhof (in the context of the SwiftTalk discussion with Brandon about the implications of this architecture) is the possibility of using conditional conformance in a protocol extension to constrain the added method to use only where `Self` is one of the expression structs that is capable of handling the feature.  That approach, of course, has its own downsides, such as mixing expression implementation-type details into a protocol that is supposed to be more oriented to defining content.


[^1]: One of the required methods used in Brandon's proof of concept combines two instances of Self into a new instance of Self.  That sort of method provides a potentially universal hook. 

