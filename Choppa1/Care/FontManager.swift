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
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-ExtraBoldItalic"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static func playfairDisplay(_ weight: PlayfairWeight = .regular, size: CGFloat) -> Font {
        return .custom(weight.fontName, size: size)
    }
}

enum PlayfairWeight {
    case regular
    case medium
    case semiBold
    case bold
    case black
    case extraBold
    case italic
    case mediumItalic
    case semiBoldItalic
    case boldItalic
    case blackItalic
    case extraBoldItalic
    
    var fontName: String {
        switch self {
        case .regular:
            return "PlayfairDisplay-Regular"
        case .medium:
            return "PlayfairDisplay-Medium"
        case .semiBold:
            return "PlayfairDisplay-SemiBold"
        case .bold:
            return "PlayfairDisplay-Bold"
        case .black:
            return "PlayfairDisplay-Black"
        case .extraBold:
            return "PlayfairDisplay-ExtraBold"
        case .italic:
            return "PlayfairDisplay-Italic"
        case .mediumItalic:
            return "PlayfairDisplay-MediumItalic"
        case .semiBoldItalic:
            return "PlayfairDisplay-SemiBoldItalic"
        case .boldItalic:
            return "PlayfairDisplay-BoldItalic"
        case .blackItalic:
            return "PlayfairDisplay-BlackItalic"
        case .extraBoldItalic:
            return "PlayfairDisplay-ExtraBoldItalic"
        }
    }
}
