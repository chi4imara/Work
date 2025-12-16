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
    
    static func ubuntuItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Ubuntu-LightItalic", size: size)
        case .medium:
            return .custom("Ubuntu-MediumItalic", size: size)
        case .bold:
            return .custom("Ubuntu-BoldItalic", size: size)
        default:
            return .custom("Ubuntu-Italic", size: size)
        }
    }
}

struct AppFonts {
    static let largeTitle = Font.ubuntu(32, weight: .bold)
    static let title = Font.ubuntu(24, weight: .bold)
    static let title2 = Font.ubuntu(22, weight: .medium)
    static let title3 = Font.ubuntu(20, weight: .medium)
    static let headline = Font.ubuntu(18, weight: .medium)
    static let body = Font.ubuntu(16, weight: .regular)
    static let callout = Font.ubuntu(15, weight: .regular)
    static let subheadline = Font.ubuntu(14, weight: .regular)
    static let footnote = Font.ubuntu(13, weight: .regular)
    static let caption = Font.ubuntu(12, weight: .regular)
    static let caption2 = Font.ubuntu(11, weight: .regular)
}
