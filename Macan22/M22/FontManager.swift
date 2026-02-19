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
    static func playfairDisplay(_ weight: PlayfairWeight = .regular, size: CGFloat) -> Font {
        return Font.custom(weight.fontName, size: size)
    }
}

enum PlayfairWeight {
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black
    case italic
    case mediumItalic
    case semiBoldItalic
    case boldItalic
    case extraBoldItalic
    case blackItalic
    
    var fontName: String {
        switch self {
        case .regular: return "PlayfairDisplay-Regular"
        case .medium: return "PlayfairDisplay-Medium"
        case .semiBold: return "PlayfairDisplay-SemiBold"
        case .bold: return "PlayfairDisplay-Bold"
        case .extraBold: return "PlayfairDisplay-ExtraBold"
        case .black: return "PlayfairDisplay-Black"
        case .italic: return "PlayfairDisplay-Italic"
        case .mediumItalic: return "PlayfairDisplay-MediumItalic"
        case .semiBoldItalic: return "PlayfairDisplay-SemiBoldItalic"
        case .boldItalic: return "PlayfairDisplay-BoldItalic"
        case .extraBoldItalic: return "PlayfairDisplay-ExtraBoldItalic"
        case .blackItalic: return "PlayfairDisplay-BlackItalic"
        }
    }
}
