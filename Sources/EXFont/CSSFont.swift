//
//  CSSFont.swift
//  EXAttributedString
//
//  Created by Matt Rips on 3/3/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation

public struct CSSFont {
    public var make: () -> String
}

extension CSSFont: EXFont {
    public init() {
        make = { return "" }
    }
    
    public static func font(name: String, size: Double) -> CSSFont {
        let sizeString = String(Int(size))
        return CSSFont {
            return "\(sizeString)px \(name)"
        }
    }
    
    public static func font(size: Double, family: String = "", name: String = "", bold: Bool = false, italic: Bool = false) -> CSSFont {
        let sizeString = String(Int(size))
        return CSSFont {
            return "\(bold ? "bold " : "")\(italic ? "italic " : "")\(sizeString)px \(name.isEmpty ? family : name)"
        }
    }
    
    
    public static func systemFont(ofSize size: Double) -> CSSFont {
        let sizeString = String(Int(size))
        return CSSFont {
            return "\(sizeString)px"
        }
    }
}
