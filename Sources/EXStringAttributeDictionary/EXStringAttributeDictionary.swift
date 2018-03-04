//
//  EXAttributeDictionary.swift
//  EXAttributeDictionary
//
//  Created by Matt Rips on 3/2/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation


public protocol EXStringAttributeDictionary {
    init()
    func adding(_ key: NSAttributedStringKey, _ value: Any) -> Self
    static func adding(_ key: NSAttributedStringKey, _ value: Any) -> Self
}
