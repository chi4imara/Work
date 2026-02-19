import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "Lumierepolis-Regular",
            "Lumierepolis-Bold",
            "Lumierepolis-Light",
            "Lumierepolis-Italic",
            "Lumierepolis-BoldItalic",
            "Lumierepolis-LightItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "otf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static func lumierepolis(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Lumierepolis-Light", size: size)
        case .bold:
            return .custom("Lumierepolis-Bold", size: size)
        default:
            return .custom("Lumierepolis-Regular", size: size)
        }
    }
    
    static func lumieropolisItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Lumierepolis-LightItalic", size: size)
        case .bold:
            return .custom("Lumierepolis-BoldItalic", size: size)
        default:
            return .custom("Lumierepolis-Italic", size: size)
        }
    }
}
