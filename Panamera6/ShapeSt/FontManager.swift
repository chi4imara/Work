import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "Ubuntu-Regular",
            "Ubuntu-Bold",
            "Ubuntu-BoldItalic",
            "Ubuntu-Italic",
            "Ubuntu-Light",
            "Ubuntu-LightItalic"
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
    static func lumierepolis(size: CGFloat, weight: FontWeight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Ubuntu-Light", size: size)
        case .regular:
            return .custom("Ubuntu-Regular", size: size)
        case .bold:
            return .custom("Ubuntu-Bold", size: size)
        default:
            return .custom("Ubuntu-Regular", size: size)
        }
    }
    
    enum FontWeight {
        case light, regular, bold
    }
}
