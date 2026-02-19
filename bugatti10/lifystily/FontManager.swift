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
            "Ubuntu-BoldItalic",
            "Ubuntu-Italic",
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
        switch weight {
        case .light:
            return .custom("Ubuntu-Light", size: size)
        case .medium:
            return .custom("Ubuntu-Medium", size: size)
        case .bold:
            return .custom("Ubuntu-Bold", size: size)
        default:
            return .custom("Ubuntu-Regular", size: size)
        }
    }
    
    static func ubuntuTitle() -> Font {
        return .custom("Ubuntu-Bold", size: 24)
    }
    
    static func ubuntuHeadline() -> Font {
        return .custom("Ubuntu-Medium", size: 20)
    }
    
    static func ubuntuBody() -> Font {
        return .custom("Ubuntu-Regular", size: 13)
    }
    
    static func ubuntuCaption() -> Font {
        return .custom("Ubuntu-Light", size: 12)
    }
}
