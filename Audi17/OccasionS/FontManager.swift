import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-Medium"
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
    static func lumierepolis(_ size: CGFloat, weight: FontWeight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("PlayfairDisplay-Regular", size: size)
        case .regular:
            return .custom("PlayfairDisplay-Medium", size: size)
        case .bold:
            return .custom("PlayfairDisplay-Bold", size: size)
        default:
            return .custom("PlayfairDisplay-Regular", size: size)
        }
    }
}

enum FontWeight {
    case light, regular, bold
}
