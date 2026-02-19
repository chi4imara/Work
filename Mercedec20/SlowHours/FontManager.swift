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
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            }
        }
    }
}

extension Font {
    static func playfair(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
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
    
    static func playfairItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .black:
            fontName = "PlayfairDisplay-BlackItalic"
        case .heavy, .bold:
            fontName = "PlayfairDisplay-BoldItalic"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBoldItalic"
        case .medium:
            fontName = "PlayfairDisplay-MediumItalic"
        default:
            fontName = "PlayfairDisplay-Italic"
        }
        return .custom(fontName, size: size)
    }
}
