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
    
    static func ubuntuItalic(size: CGFloat, weight: FontWeight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .light:
            fontName = "Ubuntu-LightItalic"
        case .regular:
            fontName = "Ubuntu-Italic"
        case .medium:
            fontName = "Ubuntu-MediumItalic"
        case .bold:
            fontName = "Ubuntu-BoldItalic"
        }
        
        return Font.custom(fontName, size: size)
    }
}

enum FontWeight {
    case light, regular, medium, bold
}

extension Font {
    static let appTitle = AppFonts.ubuntu(size: 28, weight: .bold)
    static let appHeadline = AppFonts.ubuntu(size: 22, weight: .medium)
    static let appSubheadline = AppFonts.ubuntu(size: 18, weight: .medium)
    static let appBody = AppFonts.ubuntu(size: 16, weight: .regular)
    static let appCaption = AppFonts.ubuntu(size: 14, weight: .regular)
    static let appSmall = AppFonts.ubuntu(size: 12, weight: .regular)
}
