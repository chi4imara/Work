import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "IBMPlexMono-Regular",
            "IBMPlexMono-Medium",
            "IBMPlexMono-Light",
            "IBMPlexMono-Bold",
            "IBMPlexMono-SemiBold",
            "IBMPlexMono-Thin",
            "IBMPlexMono-ExtraLight",
            "IBMPlexMono-Italic",
            "IBMPlexMono-BoldItalic",
            "IBMPlexMono-MediumItalic",
            "IBMPlexMono-LightItalic",
            "IBMPlexMono-SemiBoldItalic",
            "IBMPlexMono-ThinItalic",
            "IBMPlexMono-ExtraLightItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            }
        }
    }
}

extension Font {
    static func ibmPlexMono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .thin:
            fontName = "IBMPlexMono-Thin"
        case .light:
            fontName = "IBMPlexMono-Light"
        case .regular:
            fontName = "IBMPlexMono-Regular"
        case .medium:
            fontName = "IBMPlexMono-Medium"
        case .semibold:
            fontName = "IBMPlexMono-SemiBold"
        case .bold:
            fontName = "IBMPlexMono-Bold"
        default:
            fontName = "IBMPlexMono-Regular"
        }
        return Font.custom(fontName, size: size)
    }
}
