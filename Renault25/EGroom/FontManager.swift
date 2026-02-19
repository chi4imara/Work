import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-BlackItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func playfairDisplay(_ weight: Font.Weight = .regular, size: CGFloat = 16) -> Font {
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
