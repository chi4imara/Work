import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
        let fontNames = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-ExtraBoldItalic"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
            }
        }
    }
    
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black:
            return Font.custom("PlayfairDisplay-Black", size: size)
        case .bold:
            return Font.custom("PlayfairDisplay-Bold", size: size)
        case .semibold:
            return Font.custom("PlayfairDisplay-SemiBold", size: size)
        case .medium:
            return Font.custom("PlayfairDisplay-Medium", size: size)
        default:
            return Font.custom("PlayfairDisplay-Regular", size: size)
        }
    }
    
    static func playfairDisplayItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black:
            return Font.custom("PlayfairDisplay-BlackItalic", size: size)
        case .bold:
            return Font.custom("PlayfairDisplay-BoldItalic", size: size)
        case .semibold:
            return Font.custom("PlayfairDisplay-SemiBoldItalic", size: size)
        case .medium:
            return Font.custom("PlayfairDisplay-MediumItalic", size: size)
        default:
            return Font.custom("PlayfairDisplay-Italic", size: size)
        }
    }
}
