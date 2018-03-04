//
//  AppKitColor.swift
//  EXColor
//
//  Created by Matt Rips on 3/1/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation

#if os(OSX)
import AppKit

public struct AppKitColor {
    public let make: () -> NSColor
}

extension AppKitColor: EXColor {
    public init() {
        make = { return NSColor.white }
    }
    
    public static func color(red: Double, green: Double, blue: Double, alpha: Double = 1) -> AppKitColor {
        return AppKitColor {
            NSColor(red: red.clamped(to: 0...1).cgFloat, green: green.clamped(to: 0...1).cgFloat, blue: blue.clamped(to: 0...1).cgFloat, alpha: alpha.clamped(to: 0...1).cgFloat)
        }
    }
    
    public func alpha(_ alpha: Double) -> AppKitColor {
        return AppKitColor {
            return self.make().withAlphaComponent(alpha.clamped(to: 0...1).cgFloat)
        }
    }
}

#endif
