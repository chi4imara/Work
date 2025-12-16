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
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
    }
}

extension Font {
    static func ubuntu(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .light:
            fontName = "Ubuntu-Light"
        case .medium:
            fontName = "Ubuntu-Medium"
        case .bold:
            fontName = "Ubuntu-Bold"
        default:
            fontName = "Ubuntu-Regular"
        }
        return Font.custom(fontName, size: size)
    }
    
    static func ubuntuItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .light:
            fontName = "Ubuntu-LightItalic"
        case .medium:
            fontName = "Ubuntu-MediumItalic"
        case .bold:
            fontName = "Ubuntu-BoldItalic"
        default:
            fontName = "Ubuntu-Italic"
        }
        return Font.custom(fontName, size: size)
    }
}
