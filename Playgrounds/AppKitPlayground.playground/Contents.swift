//: Extensible - adjective: able to be extended; extendable

import AppKit
import PlaygroundSupport
import EXStringAttributesOSX
import EXColorOSX
import EXFontOSX

typealias Attributes = AppKitStringAttributeDictionary
typealias Font = AppKitFont
typealias Color = AppKitColor

let attributes = Attributes.adding(.foregroundColor, Color.black).adding(.font, Font.font(size: 20, family: "Times New Roman", italic: true))

let attributedString = NSAttributedString(string: "Hello, Extensible World!", attributes: attributes)

print(attributedString)

let nibFile = NSNib.Name(rawValue:"MyView")
var topLevelObjects : NSArray?

let textField = NSTextField(labelWithAttributedString: attributedString)
textField.frame = CGRect(x: 20, y: 100, width: 300, height: 100)

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
let mainView = views[0] as! NSView
mainView.addSubview(textField)
PlaygroundPage.current.liveView = views[0] as! NSView

