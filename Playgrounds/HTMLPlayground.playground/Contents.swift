//: Extensible - adjective: able to be extended; extendable

import UIKit
import WebKit
import PlaygroundSupport
import EXStringAttributesiOS
import EXColoriOS
import EXFontiOS

typealias Attributes = HTMLInlineStyle
typealias Font = CSSFont
typealias Color = CSSColor

var attributes = Attributes.adding(.foregroundColor, Color.black).adding(.font, Font.font(size: 20, family: "Times New Roman", italic: true))

let inlineStyle = attributes.make()

print(inlineStyle)

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let webView = WKWebView(frame: CGRect(x: 20, y: 100, width: 300, height: 100))
        let text = "Hello, Extensible World!"
        let span = "<span \(inlineStyle)>\(text)</span>"
        let html = "<meta name='viewport' content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><body>\(span)</body>"
        webView.loadHTMLString(html, baseURL: nil)
        
        view.addSubview(webView)
        self.view = view
    }
}
PlaygroundPage.current.liveView = MyViewController()
