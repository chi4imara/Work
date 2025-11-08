import SwiftUI

struct AppFonts {
    static func ubuntu(size: CGFloat, weight: FontWeight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .light:
            fontName = "Ubuntu-Light"
        case .regular:
            fontName = "Ubuntu-Regular"
        case .medium:
            fontName = "Ubuntu-Medium"
        case .bold:
            fontName = "Ubuntu-Bold"
        }
        
        return Font.custom(fontName, size: size)
    }
    
    static let largeTitle = ubuntu(size: 28, weight: .bold)
    static let title = ubuntu(size: 22, weight: .bold)
    static let title2 = ubuntu(size: 20, weight: .medium)
    static let headline = ubuntu(size: 18, weight: .medium)
    static let body = ubuntu(size: 16, weight: .regular)
    static let callout = ubuntu(size: 15, weight: .regular)
    static let subheadline = ubuntu(size: 14, weight: .regular)
    static let footnote = ubuntu(size: 12, weight: .regular)
    static let caption = ubuntu(size: 11, weight: .regular)
}

enum FontWeight {
    case light
    case regular
    case medium
    case bold
}

class FontRegistration {
    static func registerFonts() {
        let fontNames = [
            "Ubuntu-Light",
            "Ubuntu-Regular", 
            "Ubuntu-Medium",
            "Ubuntu-Bold",
            "Ubuntu-LightItalic",
            "Ubuntu-Italic",
            "Ubuntu-MediumItalic",
            "Ubuntu-BoldItalic"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }
}
