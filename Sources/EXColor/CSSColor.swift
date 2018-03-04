//
//  CSSColor.swift
//  EXColor
//
//  Created by Matt Rips on 3/1/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation

public struct CSSColor {
    public var make: () -> String
}

extension CSSColor: EXColor {
    public init() {
        make = { return "" }
    }
    
    public static func color(red: Double, green: Double, blue: Double, alpha: Double) -> CSSColor {
        return CSSColor {
            return "rgba(\(Int(round(red.clamped(to: 0...1) * 255))), \(Int(round(green.clamped(to: 0...1) * 255))), \(Int(round(blue.clamped(to: 0...1) * 255))), \(alpha.clamped(to: 0...1)))"
        }
    }
    
    public func alpha(_ alpha: Double) -> CSSColor {
        let text = self.make()
        var values = text.replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "").components(separatedBy: ",")
        values[values.count - 1] = String(alpha.clamped(to: 0...1))
        let result = "rgba(\(values.joined(separator: ", ")))"
        return CSSColor {
            return result
        }
    }
}
