//
//  UIKitColor.swift
//  EXColor
//
//  Created by Matt Rips on 3/1/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit

public struct UIKitColor {
    public var make: () -> UIColor
}

extension UIKitColor: EXColor {
    public init() {
        make = { return .white }
    }
    
    public static func color(red: Double, green: Double, blue: Double, alpha: Double) -> UIKitColor {
        return UIKitColor {
            return UIColor(red: red.clamped(to: 0...1).cgFloat, green: green.clamped(to: 0...1).cgFloat, blue: blue.clamped(to: 0...1).cgFloat, alpha: alpha.clamped(to: 0...1).cgFloat)
        }
    }
    
    public func alpha(_ alpha: Double) -> UIKitColor {
        return UIKitColor {
            return self.make().withAlphaComponent(alpha.cgFloat)
        }
    }
}

#endif
