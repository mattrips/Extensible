//
//  NSAttributedString.swift
//  EXAttributedString
//
//  Created by Matt Rips on 3/3/18.
//  Copyright © 2018 Pacism. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

extension NSAttributedString {
    #if os(iOS)
        public convenience init(string: String, attributes: UIKitStringAttributeDictionary) {
            self.init(string: string, attributes: attributes.make())
        }
    #elseif os(OSX)
        public convenience init(string: String, attributes: AppKitStringAttributeDictionary) {
            self.init(string: string, attributes: attributes.make())
        }
    #endif
}
