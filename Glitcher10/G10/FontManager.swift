import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "Ubuntu-Regular",
            "Ubuntu-Medium",
            "Ubuntu-Light",
            "Ubuntu-Bold",
            "Ubuntu-BoldItalic",
            "Ubuntu-Italic",
            "Ubuntu-LightItalic",
            "Ubuntu-MediumItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func ubuntu(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return Font.custom("Ubuntu-Light", size: size)
        case .medium:
            return Font.custom("Ubuntu-Medium", size: size)
        case .bold:
            return Font.custom("Ubuntu-Bold", size: size)
        default:
            return Font.custom("Ubuntu-Regular", size: size)
        }
    }
    
    static func ubuntuItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return Font.custom("Ubuntu-LightItalic", size: size)
        case .medium:
            return Font.custom("Ubuntu-MediumItalic", size: size)
        case .bold:
            return Font.custom("Ubuntu-BoldItalic", size: size)
        default:
            return Font.custom("Ubuntu-Italic", size: size)
        }
    }
}
