//
//  UIKitFont.swift
//  EXAttributedString
//
//  Created by Matt Rips on 3/3/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

#if os(iOS)
import UIKit

public struct UIKitFont {
    public let make: () -> UIFont?
}

extension UIKitFont: EXFont {
    public init() {
        make = { return UIFont.systemFont(ofSize: UIFont.systemFontSize) }
    }
    
    public static func font(name: String, size: Double) -> UIKitFont {
        return UIKitFont {
            return UIFont(name: name, size: size.cgFloat)
        }
    }
    
    public static func font(size: Double, family: String = "", name: String = "", bold: Bool = false, italic: Bool = false) -> UIKitFont {
        typealias Descriptor = UIFontDescriptor
        typealias DescriptorSymbolicTraits = UIFontDescriptorSymbolicTraits
        typealias Font = UIFont
        return UIKitFont {
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
                traits = traits | DescriptorSymbolicTraits.traitItalic.rawValue
            }
            if bold {
                traits = traits | DescriptorSymbolicTraits.traitBold.rawValue
            }
            descriptor = descriptor.withSymbolicTraits(DescriptorSymbolicTraits(rawValue: traits)) ?? descriptor
            return Font(descriptor: descriptor, size: size.cgFloat)
        }
    }
    
    public static func systemFont(ofSize size: Double) -> UIKitFont {
        return UIKitFont {
            return UIFont.systemFont(ofSize: size.cgFloat)
        }
    }
}

#endif
