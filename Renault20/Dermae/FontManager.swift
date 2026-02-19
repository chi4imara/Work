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
    
    static let titleLarge = Font.ubuntu(28, weight: .bold)
    static let titleMedium = Font.ubuntu(22, weight: .medium)
    static let titleSmall = Font.ubuntu(18, weight: .medium)
    static let bodyLarge = Font.ubuntu(16, weight: .regular)
    static let bodyMedium = Font.ubuntu(14, weight: .regular)
    static let bodySmall = Font.ubuntu(12, weight: .regular)
    static let caption = Font.ubuntu(10, weight: .light)
}
