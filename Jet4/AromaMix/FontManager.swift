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
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .ultraLight, .thin, .light:
            fontName = "PlayfairDisplay-Regular"
        case .regular:
            fontName = "PlayfairDisplay-Regular"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBold"
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .heavy:
            fontName = "PlayfairDisplay-ExtraBold"
        case .black:
            fontName = "PlayfairDisplay-Black"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        return Font.custom(fontName, size: size)
    }
    
    static func playfairDisplayItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .ultraLight, .thin, .light:
            fontName = "PlayfairDisplay-Italic"
        case .regular:
            fontName = "PlayfairDisplay-Italic"
        case .medium:
            fontName = "PlayfairDisplay-MediumItalic"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBoldItalic"
        case .bold:
            fontName = "PlayfairDisplay-BoldItalic"
        case .heavy:
            fontName = "PlayfairDisplay-ExtraBoldItalic"
        case .black:
            fontName = "PlayfairDisplay-BlackItalic"
        default:
            fontName = "PlayfairDisplay-Italic"
        }
        return Font.custom(fontName, size: size)
    }
}

struct AppFonts {
    static let largeTitle = Font.playfairDisplay(size: 34, weight: .bold)
    static let title = Font.playfairDisplay(size: 28, weight: .semibold)
    static let title2 = Font.playfairDisplay(size: 22, weight: .semibold)
    static let title3 = Font.playfairDisplay(size: 20, weight: .medium)
    static let headline = Font.playfairDisplay(size: 17, weight: .semibold)
    static let body = Font.playfairDisplay(size: 17, weight: .regular)
    static let callout = Font.playfairDisplay(size: 16, weight: .regular)
    static let subheadline = Font.playfairDisplay(size: 15, weight: .regular)
    static let footnote = Font.playfairDisplay(size: 13, weight: .regular)
    static let caption = Font.playfairDisplay(size: 12, weight: .regular)
    static let caption2 = Font.playfairDisplay(size: 11, weight: .regular)
}
