//
//  EXFont.swift
//  EXAttributedString
//
//  Created by Matt Rips on 3/3/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation

public protocol EXFont {
    init()
    static func font(name: String, size: Double) -> Self
    static func font(size: Double, family: String, name: String, bold: Bool, italic: Bool) -> Self
    static func systemFont(ofSize size: Double) -> Self
}
