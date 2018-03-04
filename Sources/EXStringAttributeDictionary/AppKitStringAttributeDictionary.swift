//
//  AppKitAttributeDictionary.swift
//  EXAttributedString
//
//  Created by Matt Rips on 3/3/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

#if os(OSX)

import Foundation
import EXColorOSX
import EXFontOSX

public struct AppKitStringAttributeDictionary {
    public let make: () -> [NSAttributedStringKey:Any]
}

extension AppKitStringAttributeDictionary: EXStringAttributeDictionary {
    public init() {
        make = { return [:] }
    }
    
    public func adding(_ key: NSAttributedStringKey, _ value: Any) -> AppKitStringAttributeDictionary {
        var currentDictionary = self.make()
        return AppKitStringAttributeDictionary {
            switch value {
            case is AppKitColor:
                currentDictionary[key] = (value as! AppKitColor).make()
            case is AppKitFont:
                currentDictionary[key] = (value as! AppKitFont).make()
            default:
                currentDictionary[key] = value
            }
            return currentDictionary
        }
    }
    
    public static func adding(_ key: NSAttributedStringKey, _ value: Any) -> AppKitStringAttributeDictionary {
        return AppKitStringAttributeDictionary().adding(key, value)
    }
}

#endif
