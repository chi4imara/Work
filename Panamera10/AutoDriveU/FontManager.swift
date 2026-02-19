import CoreText
import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    enum PlayfairDisplay: String {
        case regular = "PlayfairDisplay-Regular"
        case medium = "PlayfairDisplay-Medium"
        case semiBold = "PlayfairDisplay-SemiBold"
        case bold = "PlayfairDisplay-Bold"
        case extraBold = "PlayfairDisplay-ExtraBold"
        case black = "PlayfairDisplay-Black"
        case italic = "PlayfairDisplay-Italic"
        case mediumItalic = "PlayfairDisplay-MediumItalic"
        case semiBoldItalic = "PlayfairDisplay-SemiBoldItalic"
        case boldItalic = "PlayfairDisplay-BoldItalic"
        case extraBoldItalic = "PlayfairDisplay-ExtraBoldItalic"
        case blackItalic = "PlayfairDisplay-BlackItalic"
    }
    
    func reg() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium", 
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-ExtraBoldItalic",
            "PlayfairDisplay-BlackItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if let error = error {
                    print("Failed to register font \(font): \(error)")
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
    }
    
    static func playfairDisplay(_ style: PlayfairDisplay, size: CGFloat) -> Font {
        return Font.custom(style.rawValue, size: size)
    }
    
    static let largeTitle = playfairDisplay(.bold, size: 34)
    static let title1 = playfairDisplay(.semiBold, size: 28)
    static let title2 = playfairDisplay(.semiBold, size: 22)
    static let title3 = playfairDisplay(.medium, size: 20)
    static let headline = playfairDisplay(.semiBold, size: 17)
    static let body = playfairDisplay(.regular, size: 17)
    static let callout = playfairDisplay(.regular, size: 16)
    static let subheadline = playfairDisplay(.medium, size: 15)
    static let footnote = playfairDisplay(.regular, size: 13)
    static let caption1 = playfairDisplay(.regular, size: 12)
    static let caption2 = playfairDisplay(.regular, size: 11)
}
