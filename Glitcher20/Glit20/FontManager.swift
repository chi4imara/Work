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
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-BlackItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black:
            return .custom("PlayfairDisplay-Black", size: size)
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
}
