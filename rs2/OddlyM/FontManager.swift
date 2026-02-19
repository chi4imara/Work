import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "CrimsonText-Regular",
            "CrimsonText-Bold",
            "CrimsonText-BoldItalic",
            "CrimsonText-Italic",
            "CrimsonText-SemiBold",
            "CrimsonText-SemiBoldItalic"
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
    static func crimsonText(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .bold:
            return .custom("CrimsonText-Bold", size: size)
        case .semibold:
            return .custom("CrimsonText-SemiBold", size: size)
        default:
            return .custom("CrimsonText-Regular", size: size)
        }
    }
    
    static func crimsonTextItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .bold:
            return .custom("CrimsonText-BoldItalic", size: size)
        case .semibold:
            return .custom("CrimsonText-SemiBoldItalic", size: size)
        default:
            return .custom("CrimsonText-Italic", size: size)
        }
    }
}
