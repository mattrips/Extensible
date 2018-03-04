//
//  HTMLInlineStyle.swift
//  ExAttributedString
//
//  Created by Matt Rips on 3/3/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

#if os(iOS)
    import UIKit
    import EXColoriOS
    import EXFontiOS
#elseif os(OSX)
    import AppKit
    import EXColorOSX
    import EXFontOSX
#endif

public struct HTMLInlineStyle {
    public let make: () -> String
}

extension HTMLInlineStyle: EXStringAttributeDictionary {
    public init() {
        make = { return "style=\"\"" } // empty inline style
    }
    
    public func adding(_ key: NSAttributedStringKey, _ value: Any) -> HTMLInlineStyle {
        var inlineStyle = String(self.make().dropLast()) // drop the closing quote
        return HTMLInlineStyle {
            switch key {
            case NSAttributedStringKey.foregroundColor:
                if let cssColor = (value as? CSSColor)?.make() {
                    inlineStyle += "color:\(cssColor);"
                } else {
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                }
            case NSAttributedStringKey.backgroundColor:
                if let cssColor = (value as? CSSColor)?.make() {
                    inlineStyle += "background-color:\(cssColor);"
                } else {
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                }
            case NSAttributedStringKey.underlineColor, NSAttributedStringKey.strikethroughColor:
                if let cssColor = (value as? CSSColor)?.make() {
                    inlineStyle += "-webkit-text-decoration-color:\(cssColor);"
                } else {
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                }
            case NSAttributedStringKey.underlineStyle:
                inlineStyle += "-webkit-text-decoration-line:"
                guard let underlineValue = value as? Int else {
                    inlineStyle += "none;"
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                    break
                }
                switch underlineValue {
                case NSUnderlineStyle.styleNone.rawValue:
                    inlineStyle += "none;"
                case NSUnderlineStyle.styleSingle.rawValue:
                    inlineStyle += "underline;"
                case NSUnderlineStyle.styleDouble.rawValue:
                    inlineStyle += "underline;-webkit-text-decoration-style:double;"
                case NSUnderlineStyle.byWord.rawValue:
                    inlineStyle += "underline;-webkit-text-decoration-skip: spaces;"
                case NSUnderlineStyle.patternDot.rawValue:
                    inlineStyle += "underline;-webkit-text-decoration-style: dotted;"
                case NSUnderlineStyle.patternDash.rawValue:
                    inlineStyle += "underline;-webkit-text-decoration-style: dashed;"
                default:
                    inlineStyle += "none;"
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                }
            case NSAttributedStringKey.strikethroughStyle:
                inlineStyle += "-webkit-text-decoration-line:"
                guard let strikethroughValue = value as? Int else {
                    inlineStyle += "none;"
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                    break
                }
                switch strikethroughValue {
                case NSUnderlineStyle.styleNone.rawValue:
                    inlineStyle += "none;"
                case NSUnderlineStyle.styleSingle.rawValue:
                    inlineStyle += "line-through;"
                case NSUnderlineStyle.styleDouble.rawValue:
                    inlineStyle += "line-through;-webkit-text-decoration-style:double;"
                default:
                    inlineStyle += "none;"
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                }
            case NSAttributedStringKey.font:
                if let cssFont = (value as? CSSFont)?.make() {
                    inlineStyle += "font:\(cssFont);"
                } else {
                    print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
                }
            default:
                print("HTMLInlineStyle error: unsupported or invalid value for key \(key.rawValue)")
            }
            inlineStyle += "\"" // add the closing quote
            return inlineStyle
        }
    }
    
    public static func adding(_ key: NSAttributedStringKey, _ value: Any) -> HTMLInlineStyle {
        return HTMLInlineStyle().adding(key, value)
    }
}

