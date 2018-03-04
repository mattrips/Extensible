//
//  AppKitFont.swift
//  EXAttributedString
//
//  Created by Matt Rips on 3/3/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

#if os(OSX)
import AppKit

public struct AppKitFont {
    public let make: () -> NSFont?
}

extension AppKitFont: EXFont {
    public init() {
        make = { return NSFont.systemFont(ofSize: NSFont.systemFontSize) }
    }
    
    public static func font(name: String, size: Double) -> AppKitFont {
        return AppKitFont {
            return NSFont(name: name, size: size.cgFloat)
        }
    }
    
    public static func font(size: Double, family: String = "", name: String = "", bold: Bool = false, italic: Bool = false) -> AppKitFont {
        typealias Descriptor = NSFontDescriptor
        typealias DescriptorSymbolicTraits = NSFontDescriptor.SymbolicTraits
        typealias Font = NSFont
        return AppKitFont {
            var fontAttributes:[Descriptor.AttributeName:Any] = [:]
            fontAttributes[Descriptor.AttributeName.size] = NSNumber(value: size)
            if !family.isEmpty {
                fontAttributes[Descriptor.AttributeName.family] = family
            }
            if !name.isEmpty {
                fontAttributes[Descriptor.AttributeName.name] = name
            }
            var descriptor = Descriptor(fontAttributes: fontAttributes)
            var traits: UInt32 = descriptor.symbolicTraits.rawValue
            if italic {
                traits = traits | DescriptorSymbolicTraits.italic.rawValue
            }
            if bold {
                traits = traits | DescriptorSymbolicTraits.bold.rawValue
            }
            descriptor = descriptor.withSymbolicTraits(DescriptorSymbolicTraits(rawValue: traits))
            return Font(descriptor: descriptor, size: size.cgFloat)
        }
    }
    
    public static func systemFont(ofSize size: Double) -> AppKitFont {
        return AppKitFont {
            return NSFont.systemFont(ofSize: size.cgFloat)
        }
    }
}

#endif

