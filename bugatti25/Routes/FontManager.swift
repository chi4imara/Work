import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
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
            }
        }
    }
}

extension Font {
    static func playfairDisplay(_ weight: Font.Weight = .regular, size: CGFloat = 16) -> Font {
        let fontName: String
        switch weight {
        case .black:
            fontName = "PlayfairDisplay-Black"
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .heavy:
            fontName = "PlayfairDisplay-ExtraBold"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBold"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        return Font.custom(fontName, size: size)
    }
}
