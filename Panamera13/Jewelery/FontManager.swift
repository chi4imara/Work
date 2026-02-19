import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "Lumierepolis-Regular",
            "Lumierepolis-Bold",
            "Lumierepolis-BoldItalic",
            "Lumierepolis-Italic",
            "Lumierepolis-Light",
            "Lumierepolis-LightItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "otf") {
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
    static func lumierepolis(_ size: CGFloat, weight: FontWeight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Lumierepolis-Light", size: size)
        case .regular:
            return .custom("Lumierepolis-Regular", size: size)
        case .bold:
            return .custom("Lumierepolis-Bold", size: size)
        default:
            return .custom("Lumierepolis-Regular", size: size)
        }
    }
}

enum FontWeight {
    case light, regular, bold
}
