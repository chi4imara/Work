import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
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
}

extension Font {
    static func ubuntu(_ style: UbuntuStyle, size: CGFloat) -> Font {
        return Font.custom(style.rawValue, size: size)
    }
}

enum UbuntuStyle: String {
    case regular = "Ubuntu-Regular"
    case medium = "Ubuntu-Medium"
    case light = "Ubuntu-Light"
    case bold = "Ubuntu-Bold"
    case italic = "Ubuntu-Italic"
    case boldItalic = "Ubuntu-BoldItalic"
    case lightItalic = "Ubuntu-LightItalic"
    case mediumItalic = "Ubuntu-MediumItalic"
}
