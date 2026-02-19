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
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
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
    
    static func ubuntu(_ size: CGFloat, weight: FontWeight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Ubuntu-Light", size: size)
        case .regular:
            return .custom("Ubuntu-Regular", size: size)
        case .medium:
            return .custom("Ubuntu-Medium", size: size)
        case .bold:
            return .custom("Ubuntu-Bold", size: size)
        }
    }
    
    enum FontWeight {
        case light, regular, medium, bold
    }
}
