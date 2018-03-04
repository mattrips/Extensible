//
//  Double.swift
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

extension Double {
    #if os(iOS)
        internal var cgFloat: CGFloat {
            return CGFloat(self)
        }
    #elseif os(OSX)
        internal var cgFloat: CGFloat {
            return CGFloat(self)
        }
    #endif
}

extension Double {
    internal func clamped(to limits: ClosedRange<Double>) -> Double {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
