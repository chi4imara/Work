import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    enum UbuntuFont: String {
        case regular = "Ubuntu-Regular"
        case bold = "Ubuntu-Bold"
        case light = "Ubuntu-Light"
        case medium = "Ubuntu-Medium"
        case italic = "Ubuntu-Italic"
        case boldItalic = "Ubuntu-BoldItalic"
        case lightItalic = "Ubuntu-LightItalic"
        case mediumItalic = "Ubuntu-MediumItalic"
    }
    
    static func ubuntu(_ weight: UbuntuFont, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
    
    static func title(_ weight: UbuntuFont = .bold) -> Font {
        return ubuntu(weight, size: 28)
    }
    
    static func headline(_ weight: UbuntuFont = .medium) -> Font {
        return ubuntu(weight, size: 20)
    }
    
    static func body(_ weight: UbuntuFont = .regular) -> Font {
        return ubuntu(weight, size: 16)
    }
    
    static func caption(_ weight: UbuntuFont = .light) -> Font {
        return ubuntu(weight, size: 14)
    }
    
    static func small(_ weight: UbuntuFont = .light) -> Font {
        return ubuntu(weight, size: 12)
    }
    
    func registerFonts() {
        let fonts = [
            "Ubuntu-Regular",
            "Ubuntu-Bold", 
            "Ubuntu-Light",
            "Ubuntu-Medium",
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
