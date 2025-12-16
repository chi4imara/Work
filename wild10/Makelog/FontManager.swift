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
            "PlayfairDisplay-Black",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-ExtraBoldItalic"
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
    static func playfairDisplay(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black:
            return .custom("PlayfairDisplay-Black", size: size)
        case .heavy:
            return .custom("PlayfairDisplay-ExtraBold", size: size)
        case .bold:
            return .custom("PlayfairDisplay-Bold", size: size)
        case .semibold:
            return .custom("PlayfairDisplay-SemiBold", size: size)
        case .medium:
            return .custom("PlayfairDisplay-Medium", size: size)
        default:
            return .custom("PlayfairDisplay-Regular", size: size)
        }
    }
    
    static func playfairDisplayItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black:
            return .custom("PlayfairDisplay-BlackItalic", size: size)
        case .heavy:
            return .custom("PlayfairDisplay-ExtraBoldItalic", size: size)
        case .bold:
            return .custom("PlayfairDisplay-BoldItalic", size: size)
        case .semibold:
            return .custom("PlayfairDisplay-SemiBoldItalic", size: size)
        case .medium:
            return .custom("PlayfairDisplay-MediumItalic", size: size)
        default:
            return .custom("PlayfairDisplay-Italic", size: size)
        }
    }
}
