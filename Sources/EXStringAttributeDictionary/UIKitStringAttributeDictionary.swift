//
//  UIKitStringAttributeDictionary.swift
//  EXAttributeDictionary
//
//  Created by Matt Rips on 3/2/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

#if os(iOS)

import Foundation
import EXColoriOS
import EXFontiOS

public struct UIKitStringAttributeDictionary {
    public let make: () -> [NSAttributedStringKey:Any]
}

extension UIKitStringAttributeDictionary: EXStringAttributeDictionary {
    public init() {
        make = { return [:] }
    }
    
    public func adding(_ key: NSAttributedStringKey, _ value: Any) -> UIKitStringAttributeDictionary {
        var currentDictionary = self.make()
        return UIKitStringAttributeDictionary {
            switch value {
            case is UIKitColor:
                currentDictionary[key] = (value as! UIKitColor).make()
            case is UIKitFont:
                currentDictionary[key] = (value as! UIKitFont).make()
            default:
                currentDictionary[key] = value
            }
            return currentDictionary
        }
    }
    
    public static func adding(_ key: NSAttributedStringKey, _ value: Any) -> UIKitStringAttributeDictionary {
        return UIKitStringAttributeDictionary().adding(key, value)
    }
}

#endif
