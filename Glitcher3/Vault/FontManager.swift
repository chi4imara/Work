import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-ExtraBoldItalic",
            "PlayfairDisplay-BlackItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .black:
            fontName = "PlayfairDisplay-Black"
        case .heavy, .bold:
            fontName = "PlayfairDisplay-Bold"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBold"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        return .custom(fontName, size: size)
    }
}
