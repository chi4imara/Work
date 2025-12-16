import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "BuilderSans-Thin-100",
            "BuilderSans-Light-300",
            "BuilderSans-Regular-400",
            "BuilderSans-Medium-500",
            "BuilderSans-SemiBold-600",
            "BuilderSans-Bold-700",
            "BuilderSans-ExtraBold-800"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "otf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            } else {
                print("Font file not found: \(font)")
            }
        }
    }
}

extension Font {
    static func builderSans(_ weight: BuilderSansWeight, size: CGFloat) -> Font {
        return Font.custom(weight.fontName, size: size)
    }
}

enum BuilderSansWeight {
    case thin
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    
    var fontName: String {
        switch self {
        case .thin: return "BuilderSans-Thin"
        case .light: return "BuilderSans-Light"
        case .regular: return "BuilderSans-Regular"
        case .medium: return "BuilderSans-Medium"
        case .semiBold: return "BuilderSans-SemiBold"
        case .bold: return "BuilderSans-Bold"
        case .extraBold: return "BuilderSans-ExtraBold"
        }
    }
}
