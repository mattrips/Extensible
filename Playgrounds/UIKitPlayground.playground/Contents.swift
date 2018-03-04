//: Extensible - adjective: able to be extended; extendable

import UIKit
import PlaygroundSupport
import EXStringAttributesiOS
import EXColoriOS
import EXFontiOS

typealias Attributes = UIKitStringAttributeDictionary
typealias Font = UIKitFont
typealias Color = UIKitColor

var attributes = Attributes.adding(.foregroundColor, Color.black).adding(.font, Font.font(size: 20, family: "Times New Roman", italic: true))

let attributedString = NSAttributedString(string: "Hello, Extensible World!", attributes: attributes)

print(attributedString)

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 20, y: 100, width: 300, height: 100)
        label.attributedText = attributedString

        view.addSubview(label)
        self.view = view
    }
}
PlaygroundPage.current.liveView = MyViewController()
