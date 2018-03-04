//
//  EXColor.swift
//  EXColor
//
//  Created by Matt Rips on 3/1/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation

public protocol EXColor {
    init()
    static func color(red: Double, green: Double, blue: Double, alpha: Double) -> Self
    func alpha(_ alpha: Double) -> Self
}

extension EXColor {
    public func color(red: Double, green: Double, blue: Double, alpha: Double) -> Self {
        return Self.color(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    public static var red: Self {
        return .color(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    public static var green: Self {
        return .color(red: 0, green: 1, blue: 0, alpha: 1)
    }
    
    public static var blue: Self {
        return .color(red: 0, green: 0, blue: 1, alpha: 1)
    }
    
    public static var white: Self {
        return .color(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    public static var black: Self {
        return .color(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    public static var gray: Self {
        return .color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
}
