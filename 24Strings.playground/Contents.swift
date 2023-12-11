import UIKit

let string = "Taha$$$"
let attributeString = NSMutableAttributedString(string: string)

attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSRange(location: 0, length: 4))
attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: NSRange(location: 4, length: 3))

attributeString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 4))
attributeString.addAttribute(.foregroundColor, value: UIColor.systemYellow, range: NSRange(location: 4, length: 3))
attributeString.addAttribute(.underlineStyle, value: NSNumber(value:1), range: NSRange(location: 4, length: 3))


