
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

The intial project takes the small step of coding string attributes and expressing the same code, first, in each of iOS UIKit and OSX AppKit, and then, as HTML inline styles.  UIKit and AppKit both extend NSAttributedString, which is part of Foundation, each with their own versions of `NSAttributedStringKey` and with their dueling `UIFont`/`NSFont` and `UIColor`/`NSColor` types.  They are similar, but result in different code, using different types.  `EXStringAttributeDictionary` provides a single syntax for creating a dictionary of string attributes, with that syntax being essentially the same as the existing syntax with a bit of functional syntatic sugar in the form of chained `adding(_ key: _ value:)` to build the dictionary.

EXStringAttributeDictionary is built on top of 










