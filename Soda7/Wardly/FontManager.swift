import Foundation
import SwiftUI
import CoreText

class FontManager {
    
    private enum FontName: String {
        case playfairRegular = "PlayfairDisplay-Regular"
        case playfairBold = "PlayfairDisplay-Bold"
        case playfairSemiBold = "PlayfairDisplay-SemiBold"
        case playfairMedium = "PlayfairDisplay-Medium"
        case playfairItalic = "PlayfairDisplay-Italic"
        case playfairBoldItalic = "PlayfairDisplay-BoldItalic"
        case playfairBlack = "PlayfairDisplay-Black"
        case playfairExtraBold = "PlayfairDisplay-ExtraBold"
    }
    
    static func loadFonts() {
        let fontNames = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold", 
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-ExtraBoldItalic"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }
    
    static func playfairRegular(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairRegular.rawValue, size: size)
    }
    
    static func playfairBold(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairBold.rawValue, size: size)
    }
    
    static func playfairSemiBold(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairSemiBold.rawValue, size: size)
    }
    
    static func playfairMedium(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairMedium.rawValue, size: size)
    }
    
    static func playfairItalic(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairItalic.rawValue, size: size)
    }
    
    static func playfairBoldItalic(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairBoldItalic.rawValue, size: size)
    }
    
    static func playfairBlack(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairBlack.rawValue, size: size)
    }
    
    static func playfairExtraBold(size: CGFloat) -> Font {
        return Font.custom(FontName.playfairExtraBold.rawValue, size: size)
    }
}

struct AppTypography {
    static let largeTitle = FontManager.playfairBlack(size: 32)
    static let title1 = FontManager.playfairBold(size: 28)
    static let title2 = FontManager.playfairBold(size: 24)
    static let title3 = FontManager.playfairSemiBold(size: 20)
    
    static let headline = FontManager.playfairSemiBold(size: 18)
    static let body = FontManager.playfairRegular(size: 16)
    static let bodyMedium = FontManager.playfairMedium(size: 16)
    static let callout = FontManager.playfairRegular(size: 15)
    static let subheadline = FontManager.playfairMedium(size: 14)
    static let footnote = FontManager.playfairRegular(size: 13)
    static let caption = FontManager.playfairRegular(size: 12)
    static let caption2 = FontManager.playfairRegular(size: 11)
    
    static let buttonText = FontManager.playfairSemiBold(size: 16)
    static let navigationTitle = FontManager.playfairBold(size: 22)
    static let tabBarTitle = FontManager.playfairMedium(size: 12)
}
